# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **retro game emulator iOS application** built with SwiftUI and UIKit. It uses the DeltaCore framework architecture to support multiple gaming console emulators. Currently enabled cores: **SNES** (Super Nintendo), **NES** (Nintendo), and **GBC** (Game Boy Color). The app is designed for iOS 15.0+ and targets iPhone and iPad devices.

- IF export document.md file generate in Fix MD folder

## Build Commands

### Building the Project
```bash
xcodebuild -project GameEmulator.xcodeproj -scheme GameEmulator -configuration Debug
```

### Building for Release
```bash
xcodebuild -project GameEmulator.xcodeproj -scheme GameEmulator -configuration Release
```

### Opening in Xcode
```bash
open GameEmulator.xcodeproj
```

Note: This project uses Xcode's file system synchronized groups feature (fileSystemSynchronizedGroups), so files are automatically included when added to the directories.

## Architecture

### Core Framework Structure

The project follows a **plugin-based emulator core architecture**:

1. **DeltaCore** (`Cores/DeltaCore/`) - The base emulation framework
   - Provides `DeltaCoreProtocol` interface that all emulator cores must implement
   - Handles audio/video rendering, input management, save states, and controller support
   - Core registration system via `Delta.register(_:)`
   - Manages emulator lifecycle through `EmulatorCore` class

2. **Console-Specific Cores** (each in `Cores/` directory):
   - **SNESDeltaCore** - Super Nintendo emulator (enabled, uses snes9x C++ backend)
   - **NESDeltaCore** - Nintendo Entertainment System emulator (enabled, uses nestopia C++ backend)
   - **GBCDeltaCore** - Game Boy Color emulator (enabled, uses gambatte C++ backend)
   - **GBADeltaCore** - Game Boy Advance emulator (disabled)
   - **N64DeltaCore** - Nintendo 64 emulator (disabled)
   - Each core bridges native C/C++ emulator implementations to Swift via `EmulatorBridging` protocol

3. **Roxas** (`Cores/Roxas/`) - Shared utility framework used across cores

### Main App Structure

**GameEmulator/** - Main application code
- `GameEmulatorApp.swift` - SwiftUI app entry point
- `AppDelegate.swift` - Initializes audio session, registers cores, and starts controller monitoring
- `Views/ContentView.swift` - SwiftUI root view that wraps `GameViewController` via `UIViewControllerRepresentable`
- `Emulation/GameViewController.swift` - Main gameplay controller (subclasses DeltaCore's GameViewController)
  - Manages game lifecycle, controller input, external display support (AirPlay)
  - Handles sustain buttons feature (hold multiple buttons simultaneously)
  - Manages audio session configuration for gameplay
- `Models/Game.swift` - Conforms to `GameProtocol`, represents a game ROM with file URL and type
- `Systems/System.swift` - Maps emulator cores to game types, manages core registration
- `Scene/ExternalDisplaySceneDelegate.swift` - Handles external display (AirPlay) window management

### Key Concepts

**Core Registration Flow:**
1. `AppDelegate.application(_:didFinishLaunchingWithOptions:)` calls `registerCores()`
2. `System.allCases` iterates through enabled systems (`.snes`, `.nes`, `.gbc`)
3. Each system's `deltaCore` property returns the core instance (e.g., `SNES.core`, `NES.core`, `GBC.core`)
4. `Delta.register(_:)` adds core to `Delta.registeredCores` dictionary keyed by `GameType`

**Emulation Flow:**
1. `ContentView` creates `GameViewController` with a `Game` instance
2. Setting `gameViewController.game` triggers emulator core initialization
3. `GameViewController.updateControllers()` sets up on-screen controller and input mappings
4. `EmulatorCore` loads ROM from `game.fileURL` and starts emulation loop
5. Video frames render to `GameView` via `VideoManager`, audio plays via `AudioManager`

**Controller System:**
- **Custom SwiftUI Controllers** (SNES & NES): Custom-built SwiftUI controller views for better control and visual design
  - `SNESDirectController` with `SNESControllerView` - Direct bridge to snes9x, bypassing DeltaCore receiver system
  - `NESGameController` with `NESControllerView` - Generic controller using DeltaCore receiver system
  - Both support dynamic layouts for portrait/landscape orientations
  - Layout definitions in `SNESControllerLayout` and `NESControllerLayout`
- **Standard DeltaCore Controllers** (GBC & other systems):
  - `ControllerView` provides on-screen touch controls
  - Loads controller skins from JSON definitions matching console type
- External MFi controllers supported via `ExternalGameControllerManager`
- Input mapping system translates controller inputs to console-specific game inputs (e.g., `SNESGameInput`)

**Multi-Console Support:**
To enable additional cores, uncomment the relevant cases in `System.swift` and ensure the core frameworks are linked in the Xcode project.

## Current Game Configuration

The app is hardcoded to load `poke.gbc` (a Game Boy Color ROM) from the app bundle. The game type is set to `.gbc`. See `Game.swift:12-17` for the file loading logic. To change the loaded ROM:
1. Update the `type` property in `Game.swift` (e.g., `.snes`, `.nes`, or `.gbc`)
2. Update the `fileURL` to point to the desired ROM file in the bundle
3. Ensure the ROM file is added to the Xcode project's Copy Bundle Resources phase

### Supported ROM File Extensions
Defined in `System.swift` extension `GameType.init?(fileExtension:)`:
- **SNES**: `.smc`, `.sfc`, `.fig`
- **NES**: `.nes`
- **GBC**: `.gbc`, `.gb`
- **GBA**: `.gba` (core disabled)
- **N64**: `.n64`, `.z64` (core disabled)

## Important Implementation Notes

- The project uses **Xcode 16.1** and targets **iOS 18.1 SDK** with a minimum deployment target of **iOS 15.0**
- Development team ID: `WDU3932C9B` (update this in project settings for your team)
- Bundle identifier: `com.devgacon.GameEmulator`
- The `GameViewController` class heavily customizes the base DeltaCore implementation:
  - **Custom Layout System**: Overrides `viewDidLayoutSubviews()` to position game view at TOP of screen (not centered like base class)
  - **Custom Controllers**: Dynamically switches between SwiftUI custom controllers (SNES/NES) and standard DeltaCore controllers (GBC)
  - **Game Menu System**: In-game menu with save states, cheat codes, and settings accessible via "Menu" button
  - Custom input mappings for sustain buttons feature
  - External display (AirPlay) management with separate game views
  - Gyroscope support detection and orientation locking
  - Scene management for multi-window support on iPad
- **Game Menu Features** (`GameMenuView` + `GameMenuViewModel`):
  - Save state management (save/load/delete) via `SaveStateManager`
  - Cheat code database and activation via `CheatCodeManager` and `CheatDatabase`
  - Screenshot capture functionality
  - Pause/resume emulation when menu is shown/dismissed
- Audio session is configured for `.playback` category with `.mixWithOthers` option
- Core emulator bridges are typically Objective-C++ classes that wrap C/C++ emulator implementations

## Custom Controller Architecture

The app implements two approaches for controller input:

### SNES Direct Controller (Bypass Approach)
- **Files**: `SNESDirectController.swift`, `SNESControllerView.swift`, `SNESControllerLayout.swift`
- **Architecture**: Bypasses DeltaCore's receiver system entirely
- **Input Flow**: Touch → SwiftUI view → SNESDirectController → Direct C++ bridge to snes9x
- **Advantages**: Lower latency, more direct control
- **Implementation**: Does NOT use `GameController.addReceiver()` system

### NES Generic Controller (DeltaCore Approach)
- **Files**: `NESGameController.swift`, `NESControllerView.swift`, `NESControllerLayout.swift`, `GenericGameController.swift`
- **Architecture**: Uses DeltaCore's receiver system
- **Input Flow**: Touch → SwiftUI view → NESGameController → DeltaCore receiver → EmulatorCore
- **Advantages**: Standard DeltaCore integration, supports sustained inputs
- **Implementation**: Uses `gameController.addReceiver(emulatorCore, inputMapping:)` pattern

### Controller Selection Logic
Located in `GameViewController.updateControllers()`:
- Checks `game.type` and calls appropriate setup method
- `setupCustomSNESController()` for SNES games
- `setupCustomNESController()` for NES games
- `setupStandardController()` for GBC and other systems
- Hides standard DeltaCore `controllerView` when custom controllers are active

## Important Development Notes

### Rotation Handling
- `viewWillTransition(to:with:)` temporarily disables video rendering during rotation to prevent artifacts
- Video is re-enabled in completion block - **critical to avoid white screen bug**
- Custom controllers must be recreated with new layout definitions for new orientation

### Game View Layout
- **DO NOT call** `super.viewDidLayoutSubviews()` - base class centers the game view
- Custom implementation in `customLayoutGameViewAndController()` positions game view at TOP
- Game view maintains aspect ratio based on `emulatorCore.preferredRenderingSize`
- Controller view positioned at bottom, game view fills remaining space from top

### Menu Button Z-Order
- Menu button must stay on top of all views (including custom controllers)
- Use `self.view.bringSubviewToFront(menuButton)` after any view hierarchy changes
- Called in `viewDidLayoutSubviews()`, `updateControllers()`, and after controller setup

## Extending with New Cores

When adding a new console core:
1. Add the core framework project reference to `GameEmulator.xcodeproj`
2. Link the framework in Build Phases → Embed Frameworks
3. Uncomment/add the system case in `System.swift`
4. Import the core module in `System.swift` (e.g., `import NESDeltaCore`)
5. Update `System.allCores` to include the new core
6. Implement all switch statement cases for the new system enum value
7. Add file extension mappings in `GameType.init?(fileExtension:)`

## External Display Support

The app supports AirPlay/external displays:
- `ExternalDisplaySceneDelegate` manages the external window
- `GameViewController` coordinates game rendering across both displays
- Touch screen elements remain on device while gameplay mirrors to external display
- External display uses standard controller skins from DeltaCore

## Common Development Tasks

### Creating a Custom Controller for a New System
1. Create layout definition file (e.g., `XYZControllerLayout.swift`) with portrait/landscape layouts
2. Create controller class extending either:
   - `GenericGameController` (for DeltaCore integration) OR
   - Custom implementation (for direct bridge like SNES)
3. Create SwiftUI view (e.g., `XYZControllerView.swift`) with button overlays
4. Add setup/teardown methods in `GameViewController`:
   - `setupCustomXYZController()` - create controller, add to view hierarchy
   - `teardownCustomXYZController()` - cleanup and remove from hierarchy
5. Update `updateControllers()` to call setup method based on `game.type`

### Adding a New ROM to Test
1. Add ROM file to Xcode project
2. Ensure it's in "Copy Bundle Resources" build phase
3. Update `Game.swift`:
   ```swift
   var type: GameType = .snes // or .nes, .gbc
   var fileURL: URL {
       return Bundle.main.url(forResource: "yourROM", withExtension: "smc")!
   }
   ```

### Debugging Emulation Issues
- Check `EmulatorCore.state` - should be `.running` during gameplay
- Verify ROM loaded: check `game.fileURL` exists and is accessible
- Audio issues: verify `AVAudioSession` is configured (see `AppDelegate.configureAudioSession()`)
- Video issues: check `emulatorCore?.videoManager.isEnabled` is `true`
- Controller issues: verify correct setup method called in `updateControllers()`

### Testing on Device
- Update Development Team ID in project settings (currently `WDU3932C9B`)
- Ensure valid provisioning profile for bundle ID `com.devgacon.GameEmulator`
- For TestFlight: use Release configuration with proper code signing
