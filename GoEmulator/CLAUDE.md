# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GoEmulator is a multi-console iOS emulator supporting 6 gaming systems (GBA, NES, SNES, DS, N64, and Genesis/GBC in beta). Built with SwiftUI and DeltaCore framework, with custom direct controller implementations for enhanced performance on specific systems.

## Build & Run

### Xcode Setup
- Minimum iOS: 15.0
- Xcode 16.1+
- Swift 5.0

### Building the Project
```bash
# Open in Xcode
open GoEmulator.xcodeproj

# Build from command line
xcodebuild -project GoEmulator.xcodeproj -scheme GoEmulator -configuration Debug build
```

### Dependencies
The project uses DeltaCore framework with system-specific emulator cores. Core projects are referenced as absolute paths:
- `/Users/hieuvu/Documents/Cores/DeltaCore/`
- `/Users/hieuvu/Documents/Cores/GBADeltaCore/`
- `/Users/hieuvu/Documents/Cores/NESDeltaCore/`
- `/Users/hieuvu/Documents/Cores/SNESDeltaCore/`
- `/Users/hieuvu/Documents/Cores/N64DeltaCore/`
- `/Users/hieuvu/Documents/Cores/MelonDSDeltaCore/`
- `/Users/hieuvu/Documents/Cores/Roxas/`

SPM Dependencies:
- GoogleMobileAds
- RevenueCat
- Firebase (Analytics, Crashlytics, RemoteConfig)
- Lottie

## Architecture Overview

### Dual Controller Architecture

The codebase uses **two distinct emulation approaches**:

1. **DeltaCore-based** (NES, N64): Uses `GenericGameController<ButtonType>` with unified DeltaCore input handling
2. **Direct Bridge-based** (GBA, SNES, DS): Custom controllers (`GBADirectController`, `SNESDirectController`, `DSGameController`) using native C/Objective-C bridges for better performance

### System Organization Pattern

Each console follows this structure:
```
Emulation/[SYSTEM]/
├── Controller/           # SwiftUI views and layout
│   ├── [SYSTEM]ControllerView.swift
│   ├── [SYSTEM]ControllerLayout.swift
│   ├── [SYSTEM]ButtonView.swift
│   └── [SYSTEM]DPadView.swift
├── Input/               # Button state enums
│   └── [SYSTEM]ButtonState.swift
├── UI/                  # Themes and customization
│   ├── [SYSTEM]ControllerTheme.swift
│   └── [SYSTEM]ThemeManager.swift
└── Bridge/              # Direct controllers only
    └── [SYSTEM]InputBridge.h/mm
```

### Game Emulation Flow

```
User Selects Game
    ↓
GameViewController.handleGameChange()
    ↓
ControllerManager.setupController(for: gameType)
    ↓
Creates system-specific controller (Direct or GenericGameController)
    ↓
Creates SwiftUI ControllerView wrapped in UIHostingController
    ↓
Adds to view hierarchy
    ↓
Input flows: SwiftUI → Controller → InputBridge/DeltaCore → EmulatorCore
```

### Key Components

**GameViewController** (`Emulation/Generic/GameViewController.swift`):
- Central UIKit view controller managing emulation lifecycle
- Owns the game view (renders emulation) and controller views
- Delegates controller setup to `ControllerManager`
- Handles orientation changes, menu presentation, and audio configuration

**ControllerManager** (nested in GameViewController):
- Orchestrates all controller setup/teardown
- Manages UIHostingController lifecycle for SwiftUI controllers
- Handles background images for landscape modes
- Switches controllers based on game type

**SaveStateManager** (`GameMenu/SaveStateManager.swift`):
- Manages save states with thumbnails (`.sav` files in `Documents/SaveStates/`)
- Critical threading: Uses `Thread.sleep()` barriers during save/load for emulation thread stability
- Stores metadata in `metadata.json`

**CheatCodeManager** (`GameMenu/CheatCodeManager.swift`):
- Supports ActionReplay, GameShark, GameBoy, and raw memory formats
- Active cheats use timer-based memory writes
- Built-in cheat database per game

**GameManager** (`Managers/GameManager.swift`):
- CoreData-based game library (GameEntity model)
- Imports ROMs to `Documents/Games/` directory
- Tracks metadata: name, type, dateAdded, isFavorite, lastPlayed

## Important Patterns & Conventions

### Protocol-Driven Design

**GameButtonType Protocol**: All button enums conform, enabling generic handling:
```swift
protocol GameButtonType {
    var displayName: String { get }
    var gameInput: Input { get }          // DeltaCore input
    var controllerInput: Input { get }    // Controller skin input
    var isDPad: Bool { get }
    static var dpadButtons: [Self] { get }
}
```

### Button Input Mapping

**For Direct Bridge Systems** (GBA, SNES, DS):
- Button press → `buttonMask` (Int32) → Native C bridge → Emulator core
- Example: `GBAButtonType.a` has `buttonMask` for mGBA bridge

**For DeltaCore Systems** (NES, N64):
- Button press → `gameInput` → GenericGameController → DeltaCore InputReceiver

### Orientation Handling

Critical sequence in `GameViewController.viewWillTransition`:
1. Pause emulation
2. Resign first responder
3. Animate: updateControllerSkin() + setupController() + layoutIfNeeded()
4. Completion: becomeFirstResponder() + resume + videoManager.render()

### MVVM with Combine

State management uses `@StateObject`, `@ObservedObject`, and `@Published`:
- `GameViewModel`: Manages game state, pause/resume
- `GameMenuViewModel`: Orchestrates in-game menu tabs (Quick, States, Cheats, Settings)
- Service managers use singleton pattern: `GameManager.shared`, `SaveStateManager.shared`

### Theme System

Each system has:
- `ControllerTheme` struct (Codable) defining image names for all button states
- `ThemeManager` class (ObservableObject) for theme selection and UserDefaults persistence
- 5 preset themes per system
- DEBUG-only theme picker views

## Critical Implementation Details

### Bridging Header
Located at: `GoEmulator/GameEmulator-Bridging-Header.h`
- Required for Objective-C++ bridges (SNESInputBridge.mm, etc.)
- Must be configured in Build Settings: `$(SRCROOT)/GoEmulator/GameEmulator-Bridging-Header.h`

### Thread Safety in Save/Load
From `SaveStateManager`:
```swift
// Multiple Thread.sleep() calls ensure emulation thread stability
emulatorCore?.pause()
Thread.sleep(forTimeInterval: 0.1)  // Critical barrier
emulatorCore?.loadGameState(from: url)
Thread.sleep(forTimeInterval: 0.05)
emulatorCore?.resume()
```

### Audio Configuration
```swift
// Set in GameViewController
AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
emulatorCore.audioManager.respectsSilentMode = false
```

### UIHostingController Integration
SwiftUI controllers are embedded in UIKit hierarchy:
```swift
let hosting = UIHostingController(rootView: view)
hosting.view.backgroundColor = .clear
hosting.view.isUserInteractionEnabled = true
parent.addChild(hosting)
// Add constraints...
hosting.didMove(toParent: parent)
```

## Adding a New Console System

1. **Create Input Module**: Define `[SYSTEM]ButtonState.swift` with enum conforming to `GameButtonType`
2. **Choose Controller Approach**:
   - DeltaCore: `typealias [SYSTEM]GameController = GenericGameController<[SYSTEM]ButtonType>`
   - Direct Bridge: Create `[SYSTEM]DirectController` + `[SYSTEM]InputBridge.h/mm`
3. **Create UI Components**: `[SYSTEM]ControllerView.swift`, `[SYSTEM]ControllerLayout.swift`, button/dpad views
4. **Create Theme System**: `[SYSTEM]ControllerTheme.swift` + `[SYSTEM]ThemeManager.swift`
5. **Register System**:
   - Add case to `System` enum in `Systems/System.swift`
   - Add to `ControllerManager.setupController()` switch statement
   - Register DeltaCore if using DeltaCore approach

## File Structure Reference

```
GoEmulator/
├── GoEmulatorApp.swift           # App entry point
├── AppDelegate.swift             # Firebase, AppTracking, RevenueCat setup
├── GameEmulator-Bridging-Header.h
├── Emulation/
│   ├── Generic/                  # GameViewController, LayoutManager
│   ├── GBA/, NES/, SNES/, DS/, N64/  # System-specific implementations
├── GameMenu/                     # In-game menu, SaveStateManager, CheatCodeManager
├── Managers/                     # GameManager (CoreData)
├── Models/                       # Game, data models
├── ViewModels/                   # Tab navigation, app-level state
├── Views/                        # Main UI screens
├── Services/                     # Firebase, Ads, IAP, Network
├── Components/                   # Reusable UI components
├── Extensions/                   # View extensions, Color+Hex, etc.
├── Systems/                      # System enum
└── Resources/                    # Assets, Lottie files
```

## Testing & Debugging

### Manual Controller Testing
For each system, verify:
- All buttons respond correctly
- D-pad supports 8 directions (4 cardinal + 4 diagonal)
- Multiple simultaneous button presses work
- No stuck buttons after rapid presses
- Orientation changes preserve controller state

### Debug Logging
Enable in InputBridge implementations:
```objective-c
NSLog(@"Press button %ld for player %ld", (long)button, (long)playerIndex);
```

### Common Issues

**Buttons Not Responding**:
- Check bridging header path in Build Settings
- Verify emulator core headers are in Header Search Paths
- Ensure `.mm` files are marked as Objective-C++ in File Inspector

**Orientation Issues**:
- Verify `viewWillTransition` is called
- Check LayoutManager calculations for new screen size
- Ensure controller is recreated on rotation

## Reference Documentation

See `Emulation/SNES/README.md` for detailed example of custom controller implementation with direct bridge integration.
