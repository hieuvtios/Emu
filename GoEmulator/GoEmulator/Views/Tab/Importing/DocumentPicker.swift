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
    
    init(documentTypes: Set<String>) {
        self.documentTypes = documentTypes
        
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
        let supportedTypes = self.documentTypes.compactMap { UTType($0) }
        let documentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPickerViewController.delegate = context.coordinator
        documentPickerViewController.overrideUserInterfaceStyle = .dark
        documentPickerViewController.allowsMultipleSelection = true
        
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
            self.finish(with: Set(urls), errors: [])
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.finish(with: nil, errors: [])
        }
        
        private func finish(with urls: Set<URL>?, errors: [Error])
        {
            DispatchQueue.main.async {
                if let urls = urls
                {
                    //self.delegate?.importController(self, didImportItemsAt: urls, errors: errors)
                } else {
                    //self.delegate?.importControllerDidCancel(self)
                }
            }
        }
    }
}
