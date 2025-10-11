//
//  DocumentPicker.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 5/10/25.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {

    let documentTypes: Set<String>
    private let importQueue: OperationQueue
    private let fileCoordinator: NSFileCoordinator
    var onFilePicked: (([URL]) -> Void)?

    init(documentTypes: Set<String>, onFilePicked: (([URL]) -> Void)? = nil) {
        // Supported game file extensions from System.swift
        if documentTypes.isEmpty {
            self.documentTypes = [
                "nes",                          // NES
                "smc", "sfc", "fig",           // SNES
                "gbc", "gb",                   // Game Boy Color
                "gba",                         // Game Boy Advance
                "ds", "nds",                   // Nintendo DS
                "gen", "bin", "md", "smd"      // Sega Genesis
            ]
        } else {
            self.documentTypes = documentTypes
        }

        self.onFilePicked = onFilePicked

        let dispatchQueue = DispatchQueue(label: "com.rileytestut.Delta.ImportController.dispatchQueue", qos: .userInitiated, attributes: .concurrent)

        self.importQueue = OperationQueue()
        self.importQueue.name = "com.rileytestut.Delta.ImportController.importQueue"
        self.importQueue.underlyingQueue = dispatchQueue

        self.fileCoordinator = NSFileCoordinator(filePresenter: nil)
    }
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        // Use .data and .item to allow all file types, including custom ROM extensions
        // This allows .nes, .gba, .smc, etc. which don't have predefined UTTypes
        let supportedTypes: [UTType] = [.data, .item]

        let documentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPickerViewController.delegate = context.coordinator
        documentPickerViewController.overrideUserInterfaceStyle = .dark
        documentPickerViewController.allowsMultipleSelection = true
        documentPickerViewController.shouldShowFileExtensions = true

        return documentPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {

        var parent: DocumentPicker

        init(parent1: DocumentPicker){
            parent = parent1
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("📁 Document picker received \(urls.count) file(s)")

            // Filter URLs to only include supported game file extensions
            let validURLs = urls.filter { url in
                let fileExtension = url.pathExtension.lowercased()
                let isValid = self.parent.documentTypes.contains(fileExtension)
                print("📄 File: \(url.lastPathComponent), Extension: \(fileExtension), Valid: \(isValid)")
                return isValid
            }

            if validURLs.isEmpty {
                print("❌ No valid game files selected. Supported extensions: \(self.parent.documentTypes)")
                self.finish(with: nil, errors: [])
                return
            }

            print("✅ Valid files: \(validURLs.count)")
            let importedURLs = self.importFiles(validURLs)
            print("📦 Successfully imported \(importedURLs.count) file(s)")
            self.finish(with: importedURLs, errors: [])
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.finish(with: nil, errors: [])
        }

        private func importFiles(_ urls: [URL]) -> [URL] {
            var importedURLs: [URL] = []

            // Get app's Documents directory
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to access documents directory")
                return []
            }

            let gamesDirectory = documentsDirectory.appendingPathComponent("ImportedGames", isDirectory: true)

            // Create ImportedGames directory if it doesn't exist
            do {
                try FileManager.default.createDirectory(at: gamesDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create ImportedGames directory: \(error)")
                return []
            }

            for url in urls {
                // Since we used asCopy: true, files are already copied to temp location by the system
                // We just need to move them to our permanent storage
                let fileName = url.lastPathComponent
                let destinationURL = gamesDirectory.appendingPathComponent(fileName)

                do {
                    // Remove existing file if present
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }

                    // Move or copy file to Documents directory
                    // Try to move first (more efficient), fall back to copy
                    do {
                        try FileManager.default.moveItem(at: url, to: destinationURL)
                    } catch {
                        // If move fails, try to copy
                        try FileManager.default.copyItem(at: url, to: destinationURL)
                    }

                    importedURLs.append(destinationURL)
                    print("Successfully imported game: \(fileName) to \(destinationURL.path)")
                } catch {
                    print("Failed to import file \(fileName): \(error.localizedDescription)")
                }
            }

            return importedURLs
        }

        private func finish(with urls: [URL]?, errors: [Error]) {
            DispatchQueue.main.async {
                if let urls = urls, !urls.isEmpty {
                    self.parent.onFilePicked?(urls)
                }
            }
        }
    }
}
