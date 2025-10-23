//
//  GameMenuView.swift
//  GameEmulator
//
//  Created by Claude Code
//

import SwiftUI
import DeltaCore

struct GameMenuView: View {
    @ObservedObject var viewModel: GameMenuViewModel
    @Environment(\.dismiss) private var dismiss

    @SwiftUI.State private var selectedTab = 0
    @SwiftUI.State private var newCheatName = ""
    @SwiftUI.State private var newCheatCode = ""
    @SwiftUI.State private var selectedCheatType: CheatCodeManager.CheatType = .actionReplay

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Tab Selector
                    Picker("Menu", selection: $selectedTab) {
                        Text("Quick").tag(0)
                        Text("States").tag(1)
                        Text("Cheats").tag(2)
                        Text("Settings").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    // Content
                    TabView(selection: $selectedTab) {
                        quickActionsView
                            .tag(0)

                        saveStatesView
                            .tag(1)

                        cheatsView
                            .tag(2)

                        settingsView
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    // Dismiss Button
                    dismissButton
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                }
            }
            .navigationTitle("Game Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }

            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

    // MARK: - Dismiss Button

    private var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "gamecontroller.fill")
                    .font(.title3)
                Text("Resume Game")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Quick Actions View

    private var quickActionsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Save/Load
                GroupBox {
                    VStack(spacing: 12) {
                        Button(action: { viewModel.quickSave() }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Quick Save")
                                Spacer()
                            }
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                        }

                        Button(action: { viewModel.quickLoad() }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Quick Load")
                                Spacer()
                            }
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                } label: {
                    Label("Save States", systemImage: "externaldrive")
                }

                // Speed Control
                GroupBox {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Current Speed:")
                            Spacer()
                            Text(viewModel.currentSpeed.displayName)
                                .fontWeight(.bold)
                        }

                        Button(action: { viewModel.toggleSpeed() }) {
                            HStack {
                                Image(systemName: "forward.fill")
                                Text("Fast Forward")
                                Spacer()
                            }
                            .padding()
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                        }

                        if viewModel.currentSpeed != .normal {
                            Button(action: { viewModel.resetSpeed() }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Reset Speed")
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                } label: {
                    Label("Speed Control", systemImage: "speedometer")
                }

                // Screenshot
                GroupBox {
                    Button(action: { viewModel.captureScreenshot() }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Take Screenshot")
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                    }
                } label: {
                    Label("Screenshot", systemImage: "camera.viewfinder")
                }
            }
            .padding()
        }
    }

    // MARK: - Save States View

    private var saveStatesView: some View {
        VStack {
            if viewModel.saveStates.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "externaldrive.badge.xmark")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No Save States")
                        .font(.headline)
                    Text("Create a save state from the Quick menu")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.saveStates) { saveState in
                        SaveStateRow(
                            saveState: saveState,
                            thumbnail: viewModel.getThumbnail(for: saveState),
                            onLoad: { viewModel.loadState(saveState) },
                            onDelete: { viewModel.deleteState(saveState) }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Cheats View

    private var cheatsView: some View {
        VStack {
            List {
                Section {
                    Button(action: { viewModel.showingCheatInput = true }) {
                        Label("Add Cheat Code", systemImage: "plus.circle")
                    }

                    if !viewModel.availableBuiltInCheats.isEmpty {
                        Button(action: { viewModel.showingCheatDatabase = true }) {
                            Label("Browse Cheat Database", systemImage: "book.fill")
                        }
                    }
                }

                if !viewModel.cheats.isEmpty {
                    Section("Active Cheats") {
                        ForEach(viewModel.cheats) { cheat in
                            CheatRow(
                                cheat: cheat,
                                onToggle: { viewModel.toggleCheat(cheat) },
                                onDelete: { viewModel.deleteCheat(cheat) }
                            )
                        }
                    }
                } else {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "keyboard.badge.ellipsis")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("No Cheats")
                                .font(.headline)
                            Text("Add cheat codes to enhance your gameplay")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCheatInput) {
                CheatInputView(
                    name: $newCheatName,
                    code: $newCheatCode,
                    type: $selectedCheatType,
                    onAdd: {
                        viewModel.addCheat(name: newCheatName, code: newCheatCode, type: selectedCheatType)
                        newCheatName = ""
                        newCheatCode = ""
                    },
                    onCancel: {
                        viewModel.showingCheatInput = false
                        newCheatName = ""
                        newCheatCode = ""
                    }
                )
            }
            .sheet(isPresented: $viewModel.showingCheatDatabase) {
                CheatDatabaseView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Settings View

    private var settingsView: some View {
        List {
            Section("Speed Options") {
                ForEach(EmulatorCore.EmulationSpeed.allCases, id: \.rawValue) { speed in
                    Button(action: { viewModel.setSpeed(speed) }) {
                        HStack {
                            Text(speed.displayName)
                            Spacer()
                            if viewModel.currentSpeed == speed {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }

            Section("Help") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cheat Code Formats:")
                        .font(.headline)

                    ForEach([CheatCodeManager.CheatType.actionReplay, .gameShark, .gameBoy, .raw], id: \.rawValue) { type in
                        HStack {
                            Text(type.rawValue)
                                .fontWeight(.medium)
                            Spacer()
                            Text(type.codeFormat)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Save State Row

struct SaveStateRow: View {
    let saveState: SaveStateManager.SaveStateInfo
    let thumbnail: UIImage?
    let onLoad: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 60)
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(saveState.slotNumber == 0 ? "Quick Save" : "Slot \(saveState.slotNumber)")
                    .font(.headline)

                Text(saveState.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(saveState.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Actions
            Button(action: onLoad) {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Cheat Row

struct CheatRow: View {
    let cheat: CheatCodeManager.CheatCode
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(cheat.name)
                    .font(.headline)

                Text(cheat.code)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)

                Text(cheat.type.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { cheat.isEnabled },
                set: { _ in onToggle() }
            ))
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Cheat Input View

struct CheatInputView: View {
    @Binding var name: String
    @Binding var code: String
    @Binding var type: CheatCodeManager.CheatType

    let onAdd: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Cheat Details") {
                    TextField("Name", text: $name)

                    TextField("Code", text: $code)
                        .autocapitalization(.allCharacters)
                        .font(.system(.body, design: .monospaced))

                    Picker("Type", selection: $type) {
                        ForEach([CheatCodeManager.CheatType.actionReplay, .gameShark, .gameBoy, .raw], id: \.rawValue) { cheatType in
                            Text(cheatType.rawValue).tag(cheatType)
                        }
                    }
                }

                Section("Format") {
                    Text(type.codeFormat)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Cheat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: onAdd)
                        .disabled(name.isEmpty || code.isEmpty)
                }
            }
        }
    }
}

// MARK: - Cheat Database View

struct CheatDatabaseView: View {
    @ObservedObject var viewModel: GameMenuViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        viewModel.importAllBuiltInCheats()
                        dismiss()
                    }) {
                        Label("Import All Cheats", systemImage: "square.and.arrow.down.fill")
                            .foregroundColor(.blue)
                    }
                } footer: {
                    Text("Import all available cheats for this game at once")
                }

                Section("Available Cheats") {
                    ForEach(viewModel.availableBuiltInCheats) { cheat in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(cheat.name)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    viewModel.importBuiltInCheat(cheat)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(.plain)
                            }

                            Text(cheat.code)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)

                            Text(cheat.type.rawValue)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Cheat Database")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
