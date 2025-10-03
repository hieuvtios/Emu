# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **retro game emulator iOS application** built with SwiftUI and UIKit. It uses the DeltaCore framework architecture to support multiple gaming console emulators (currently configured for SNES). The app is designed for iOS 15.0+ and targets iPhone and iPad devices.

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
   - **SNESDeltaCore** - Super Nintendo emulator (currently enabled, uses snes9x C++ backend)
   - **NESDeltaCore** - Nintendo Entertainment System emulator (disabled)
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
2. `System.allCases` iterates through enabled systems (currently only `.snes`)
3. Each system's `deltaCore` property returns the core instance (e.g., `SNES.core`)
4. `Delta.register(_:)` adds core to `Delta.registeredCores` dictionary keyed by `GameType`

**Emulation Flow:**
1. `ContentView` creates `GameViewController` with a `Game` instance
2. Setting `gameViewController.game` triggers emulator core initialization
3. `GameViewController.updateControllers()` sets up on-screen controller and input mappings
4. `EmulatorCore` loads ROM from `game.fileURL` and starts emulation loop
5. Video frames render to `GameView` via `VideoManager`, audio plays via `AudioManager`

**Controller System:**
- `ControllerView` (from DeltaCore) provides on-screen touch controls
- Loads controller skins from JSON definitions matching console type
- External MFi controllers supported via `ExternalGameControllerManager`
- Input mapping system translates controller inputs to console-specific game inputs (e.g., `SNESGameInput`)

**Multi-Console Support:**
To enable additional cores, uncomment the relevant cases in `System.swift` and ensure the core frameworks are linked in the Xcode project.

## Current Game Configuration

The app is hardcoded to load `demo.smc` (a SNES ROM) from the app bundle. See `Game.swift:15` for the file loading logic.

## Important Implementation Notes

- The project uses **Xcode 16.1** and targets **iOS 18.1 SDK** with a minimum deployment target of **iOS 15.0**
- Development team ID: `WDU3932C9B` (update this in project settings for your team)
- Bundle identifier: `com.devgacon.GameEmulator`
- The `GameViewController` class heavily customizes the base DeltaCore implementation:
  - Custom input mappings for sustain buttons feature
  - External display (AirPlay) management with separate game views
  - Gyroscope support detection and orientation locking
  - Scene management for multi-window support on iPad
- Audio session is configured for `.playback` category with `.mixWithOthers` option
- Core emulator bridges are typically Objective-C++ classes that wrap C/C++ emulator implementations

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
