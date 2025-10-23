# N64 Controller Implementation Summary

## Overview
Complete Nintendo 64 controller implementation following the same architecture as GBA. This implementation provides a direct bridge to the N64DeltaCore (Mupen64Plus) for low-latency input handling.

## Architecture

### Pattern Followed
The N64 controller follows the **Direct Controller Architecture** used by GBA, SNES, NES, and Genesis systems:
- Direct C++/Objective-C bridge bypassing DeltaCore receiver system
- SwiftUI-based custom controller views
- Separate layout definitions for portrait and landscape orientations
- Thread-safe input bridge with unfair lock mechanism

## File Structure

```
GameEmulator/Emulation/N64/
├── Input/
│   └── N64ButtonState.swift           # Button state management and input mappings
├── Controller/
│   ├── N64DirectController.swift      # Direct controller class
│   ├── N64ControllerLayout.swift      # Portrait/landscape layouts
│   ├── N64ButtonView.swift            # Button components
│   ├── N64DPadView.swift              # D-Pad component
│   ├── N64CButtonView.swift           # C-button cluster (unique to N64)
│   └── N64ControllerView.swift        # Main controller view
└── Bridge/
    ├── N64InputBridge.h               # Objective-C bridge header
    └── N64InputBridge.mm              # Objective-C++ bridge implementation
```

## Created Files

### 1. N64ButtonState.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Input/N64ButtonState.swift`

**Purpose:** Defines button types, input mappings, and state tracking for N64 controller

**Key Components:**
- `N64ButtonType` enum: 14 buttons (D-Pad x4, A, B, C-buttons x4, L, R, Z, Start)
- Button mask mappings for Mupen64Plus input values
- `N64ControllerInput` struct: DeltaCore input wrapper
- `N64ButtonStateTracker`: Thread-safe button state management
- Special arrays: `dpadButtons` and `cButtons` for grouped button handling

**Button Masks:**
```swift
.up:     2048   // D-Pad Up
.down:   4096   // D-Pad Down
.left:   512    // D-Pad Left
.right:  1024   // D-Pad Right
.a:      128    // A button (blue, primary)
.b:      64     // B button (green)
.cUp:    8      // C-Up (yellow)
.cDown:  4      // C-Down (yellow)
.cLeft:  2      // C-Left (yellow)
.cRight: 1      // C-Right (yellow)
.l:      32     // L shoulder
.r:      16     // R shoulder
.z:      8192   // Z trigger
.start:  256    // Start button
```

### 2. N64InputBridge.h & N64InputBridge.mm
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Bridge/`

**Purpose:** Direct bridge between Swift UI and Mupen64Plus C++ emulator core

**Key Features:**
- Singleton pattern with thread-safe access
- `os_unfair_lock` for thread synchronization
- Direct interface to N64EmulatorBridge from N64DeltaCore
- Methods: `pressButton`, `releaseButton`, `resetAllInputs`

**Architecture:**
```
SwiftUI Touch → N64ControllerView → N64DirectController → N64InputBridge → N64EmulatorBridge → Mupen64Plus Core
```

### 3. N64DirectController.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64DirectController.swift`

**Purpose:** Swift wrapper for N64InputBridge with high-level button control

**Key Features:**
- Player index support (future multiplayer)
- Grouped button handling for D-Pad and C-buttons
- Automatic cleanup on deinit
- Simple API: `pressButton()`, `releaseButton()`, `reset()`

### 4. N64ControllerLayout.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64ControllerLayout.swift`

**Purpose:** Defines button positions and sizes for portrait/landscape orientations

**Layout Structures:**
- `ButtonLayout`: Individual button position and size
- `DPadLayout`: D-Pad center and radius
- `CButtonLayout`: C-button cluster configuration (unique to N64)
- `N64ControllerLayoutDefinition`: Complete layout container

**Landscape Layout:**
- D-Pad: Left side, centered vertically
- A/B buttons: Right side, lower position (A larger, B smaller)
- C-button cluster: Right side, upper position (4 yellow buttons in + pattern)
- L/R triggers: Top left and right corners
- Z trigger: Below L trigger
- Start: Top center

**Portrait Layout:**
- D-Pad: Lower left at 65% screen height
- A/B buttons: Lower right
- C-button cluster: Upper right
- L/R triggers: Top area, 160px below controls
- Z trigger: Below L trigger
- Start: Bottom center

### 5. N64ButtonView.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64ButtonView.swift`

**Purpose:** SwiftUI button components with authentic N64 styling

**Components:**
- `N64ButtonView`: Main circular buttons (A, B)
- `N64ShoulderButtonView`: Rectangular L/R shoulder buttons
- `N64ZButtonView`: Z trigger button (smaller rectangular)
- `N64StartButtonView`: Start button (red capsule)

**Button Colors:**
- A button: Blue (`rgb(0.2, 0.4, 0.9)`)
- B button: Green (`rgb(0.2, 0.8, 0.3)`)
- L/R buttons: Gray
- Z button: Dark gray (`gray 0.3`)
- Start button: Red

**Features:**
- Haptic feedback on press (UIImpactFeedbackGenerator)
- Press/release animations (scale effect)
- Shadow effects (removed when pressed)
- DragGesture for smooth touch handling

### 6. N64DPadView.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64DPadView.swift`

**Purpose:** D-Pad component with 8-directional input support

**Key Features:**
- Custom cross-shaped D-Pad using `DPadShape`
- 8-directional input (cardinals + diagonals)
- Dead zone threshold (20% of radius)
- Visual direction indicators (SF Symbols arrows)
- Touch location indicator
- Angle-based button calculation

**Input Logic:**
- Calculates angle from touch to D-Pad center
- Maps 45-degree sectors to directions
- Supports diagonal inputs (e.g., up+right)
- Dead zone prevents accidental inputs

### 7. N64CButtonView.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64CButtonView.swift`

**Purpose:** Unique C-button cluster (4 yellow buttons in cross pattern)

**Key Features:**
- 4 buttons arranged in + pattern (C-Up, C-Down, C-Left, C-Right)
- Yellow color scheme (`rgb(1.0, 0.85, 0.0)`)
- Direction arrow indicators (SF Symbols)
- Background circle container
- Proximity-based button detection

**Layout:**
- Center point defines cluster position
- Spacing defines distance between buttons
- Buttons arranged in cardinal directions from center
- Touch detection uses distance calculation

**Behavior:**
- Single button active at a time
- Automatic release when switching buttons
- Haptic feedback on button change
- Touch indicator shows current touch position

### 8. N64ControllerView.swift
**Path:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/Emulation/N64/Controller/N64ControllerView.swift`

**Purpose:** Main controller view assembling all components

**Component Hierarchy (by z-index):**
1. Background (z: 0) - Semi-transparent black
2. D-Pad (z: 1)
3. Action buttons & C-button cluster (z: 2)
4. Shoulder buttons & Z button (z: 3)
5. Start button (z: 4)

**State Management:**
- `@State buttonStates`: Tracks individual button pressed states
- `@State dpadButtons`: Tracks currently pressed D-Pad directions
- `@State cButtons`: Tracks currently pressed C-buttons

**Features:**
- SwiftUI preview providers for both orientations
- Binding-based state synchronization
- Gesture-based input handling
- Component composition with proper layering

## N64-Specific Implementations

### 1. C-Button Cluster
The C-button cluster is unique to N64 and required special implementation:
- 4 separate buttons arranged in cross pattern
- Yellow color scheme (authentic N64 styling)
- Proximity-based touch detection
- Grouped release/press handling

### 2. Z Trigger
The Z trigger is positioned uniquely on N64:
- Smaller rectangular button below L trigger
- Dark gray color to differentiate from L/R
- Separate component for specialized styling

### 3. Button Layout Philosophy
N64 controller has a three-pronged design adapted to touch screen:
- Left prong: D-Pad
- Center prong: Start button (top center position)
- Right prong: A/B buttons and C-button cluster

## Integration with GameViewController

To integrate this controller with the existing `GameViewController`, add the following methods:

```swift
// In GameViewController.swift

private func setupCustomN64Controller() {
    // Remove standard controller
    teardownStandardController()

    // Create N64 controller
    let controller = N64DirectController(name: "N64 Direct Controller", playerIndex: 0)

    // Get screen size
    let screenSize = self.view.bounds.size

    // Create layout based on orientation
    let layout: N64ControllerLayoutDefinition
    if UIDevice.current.orientation.isLandscape {
        layout = N64ControllerLayout.landscapeLayout(screenSize: screenSize)
    } else {
        layout = N64ControllerLayout.portraitLayout(screenSize: screenSize)
    }

    // Create SwiftUI controller view
    let controllerView = N64ControllerView(controller: controller, layout: layout)
    let hostingController = UIHostingController(rootView: controllerView)
    hostingController.view.backgroundColor = .clear

    // Add to view hierarchy
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.view.frame = view.bounds
    hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostingController.didMove(toParent: self)

    // Store reference
    self.customN64Controller = controller
    self.n64HostingController = hostingController

    // Ensure menu button stays on top
    if let menuButton = self.menuButton {
        self.view.bringSubviewToFront(menuButton)
    }
}

private func teardownCustomN64Controller() {
    n64HostingController?.willMove(toParent: nil)
    n64HostingController?.view.removeFromSuperview()
    n64HostingController?.removeFromParent()
    n64HostingController = nil
    customN64Controller = nil
}

// Update updateControllers() method:
func updateControllers() {
    guard let game = game else { return }

    switch game.type {
    case .n64:
        setupCustomN64Controller()
    case .snes:
        setupCustomSNESController()
    case .nes:
        setupCustomNESController()
    case .gba:
        setupCustomGBAController()
    default:
        setupStandardController()
    }
}
```

Add these properties to GameViewController:
```swift
private var customN64Controller: N64DirectController?
private var n64HostingController: UIHostingController<N64ControllerView>?
```

## Bridging Header Update

The bridging header has been updated to include N64InputBridge:
**File:** `/Users/hieuvu/Documents/GitHub/Emu/Archive/GameEmulator/GameEmulator-Bridging-Header.h`

Added line:
```objc
#import "N64InputBridge.h"
```

## Differences from GBA Implementation

### Similarities:
1. Direct bridge architecture (no DeltaCore receiver)
2. Thread-safe input handling with os_unfair_lock
3. SwiftUI-based controller views
4. Separate portrait/landscape layouts
5. Haptic feedback on button presses

### Unique to N64:
1. **C-Button Cluster**: 4 yellow buttons in cross pattern (unique component)
2. **Z Trigger**: Additional trigger button below L shoulder
3. **Button Count**: 14 buttons vs GBA's 10 buttons
4. **Color Scheme**: Blue A, Green B, Yellow C-buttons (vs GBA's red/beige)
5. **Layout Complexity**: Three-pronged design adapted to touch screen

### Implementation Differences:
1. **CButtonLayout struct**: New layout type for C-button cluster
2. **N64CButtonView**: Entirely new component not present in GBA
3. **Button grouping**: Both `dpadButtons` and `cButtons` arrays
4. **Z button handling**: Separate Z button methods in controller

## Testing

### Preview Providers
Both landscape and portrait previews are included in `N64ControllerView.swift`:
- Use Xcode canvas to preview layouts
- Test button positions and sizes
- Verify color schemes and styling

### Manual Testing Checklist:
- [ ] All buttons register press/release correctly
- [ ] D-Pad supports 8 directions including diagonals
- [ ] C-button cluster responds to all 4 directions
- [ ] Haptic feedback works on all buttons
- [ ] Layout adapts correctly to orientation changes
- [ ] Z trigger positioned correctly below L shoulder
- [ ] Start button accessible and functional
- [ ] Button colors match N64 aesthetic
- [ ] No input lag or dropped inputs
- [ ] Thread safety verified (no crashes during rapid input)

## Performance Considerations

1. **Direct Bridge**: Bypasses DeltaCore abstraction for minimal latency
2. **Unfair Lock**: Fast synchronization primitive (os_unfair_lock)
3. **SwiftUI**: Efficient declarative UI updates
4. **State Management**: Minimal state tracking with Set collections
5. **Gesture Handling**: DragGesture with minimumDistance: 0 for immediate response

## Known Limitations

1. **Analog Stick**: Not implemented (touch screen limitation)
   - N64 analog stick would require joystick component
   - Could be added in future update if needed
2. **Rumble Pak**: Not supported
3. **Controller Pak**: Not supported
4. **Multiplayer**: Framework supports it, but UI only implements player 1

## Future Enhancements

1. **Analog Stick**: Add virtual joystick component
2. **Theme System**: Add theme manager similar to SNES/NES implementations
3. **Customizable Layouts**: Allow users to adjust button positions
4. **Sensitivity Settings**: Configurable dead zones and touch sensitivity
5. **Multiple Themes**: Additional color schemes (e.g., transparent, ice blue)

## Key Architectural Decisions

### 1. Direct Bridge vs DeltaCore Receiver
**Decision:** Use direct bridge like GBA
**Rationale:** Lower latency, more control over input timing, matches existing pattern

### 2. Separate C-Button Component
**Decision:** Create dedicated `N64CButtonView` instead of individual buttons
**Rationale:**
- C-buttons function as a group (camera control, UI navigation)
- Easier to manage as single touch-sensitive cluster
- More authentic to N64's unique design

### 3. Z Button Positioning
**Decision:** Place Z below L trigger rather than separate
**Rationale:**
- Authentic N64 Z trigger is on underside of controller
- Touch screen adaptation places it near L for ergonomics
- Clear visual separation from L/R shoulder buttons

### 4. Color Scheme
**Decision:** Blue A, Green B, Yellow C-buttons
**Rationale:**
- Matches authentic N64 button colors
- High contrast for visibility
- Distinct from other console color schemes

### 5. SwiftUI vs UIKit
**Decision:** Pure SwiftUI implementation
**Rationale:**
- Matches GBA, SNES, NES, Genesis pattern
- Cleaner code with less boilerplate
- Better animation support
- Easier layout management

## Summary

The N64 controller implementation is complete and follows the established architecture patterns from GBA, SNES, and NES implementations. All components have been created with proper threading, haptic feedback, and visual polish.

**Total Files Created:** 10
- 1 Swift input/state file
- 6 Swift controller files
- 2 Objective-C++ bridge files
- 1 bridging header update

**Lines of Code:** ~1,800 lines
**Architecture:** Direct bridge with SwiftUI UI
**Unique Features:** C-button cluster, Z trigger
**Status:** Ready for integration and testing

## Integration Checklist

- [x] Create N64 directory structure
- [x] Implement button state management
- [x] Create input bridge (Objective-C++)
- [x] Implement direct controller class
- [x] Define controller layouts
- [x] Create button view components
- [x] Create D-Pad component
- [x] Create C-button cluster component
- [x] Create main controller view
- [x] Update bridging header
- [ ] Add integration code to GameViewController
- [ ] Test with N64 ROM
- [ ] Verify all buttons work correctly
- [ ] Test orientation changes
- [ ] Performance testing

## Contact Points with Existing Code

### Files that need updates:
1. **GameViewController.swift**
   - Add `setupCustomN64Controller()` method
   - Add `teardownCustomN64Controller()` method
   - Update `updateControllers()` switch statement
   - Add controller properties

2. **System.swift**
   - Already includes N64 system (.n64 case)
   - N64DeltaCore already imported
   - No changes needed

3. **Game.swift**
   - Update `type` property to `.n64` to test
   - Update `fileURL` to point to N64 ROM

### No changes needed:
- AppDelegate.swift (core registration already handles N64)
- System.swift (N64 already defined)
- ExternalDisplaySceneDelegate.swift (will use standard controller)

---

**Implementation Date:** 2025-10-17
**Architecture Version:** Direct Bridge v2.0
**Follows Pattern:** GBA/SNES/NES/Genesis Direct Controllers
**Status:** Complete - Ready for Integration
