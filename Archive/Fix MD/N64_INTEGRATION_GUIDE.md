# N64 Controller Integration Guide

## Quick Start

This guide provides step-by-step instructions to integrate the N64 controller into your GameViewController.

## Step 1: Add Properties to GameViewController

Add these properties to the `GameViewController` class:

```swift
// In GameViewController.swift, add to properties section:

private var customN64Controller: N64DirectController?
private var n64HostingController: UIHostingController<N64ControllerView>?
```

## Step 2: Add Setup Method

Add this method to `GameViewController`:

```swift
// MARK: - N64 Controller

private func setupCustomN64Controller() {
    // Remove any existing controllers
    teardownStandardController()
    teardownCustomSNESController()
    teardownCustomNESController()
    teardownCustomGBAController()
    teardownCustomGenesisController()

    // Create N64 controller
    let controller = N64DirectController(name: "N64 Direct Controller", playerIndex: 0)

    // Get screen size
    let screenSize = self.view.bounds.size

    // Create layout based on orientation
    let layout: N64ControllerLayoutDefinition
    let orientation = UIDevice.current.orientation

    if orientation.isLandscape || orientation == .unknown {
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

    // Store references
    self.customN64Controller = controller
    self.n64HostingController = hostingController

    // Hide standard controller
    self.controllerView?.isHidden = true

    // Ensure menu button stays on top
    if let menuButton = self.menuButton {
        self.view.bringSubviewToFront(menuButton)
    }

    print("✅ N64 custom controller setup complete")
}

private func teardownCustomN64Controller() {
    print("🧹 Tearing down N64 custom controller")

    n64HostingController?.willMove(toParent: nil)
    n64HostingController?.view.removeFromSuperview()
    n64HostingController?.removeFromParent()
    n64HostingController = nil

    customN64Controller?.reset()
    customN64Controller = nil
}
```

## Step 3: Update the updateControllers() Method

Modify the `updateControllers()` method to include N64:

```swift
override func updateControllers() {
    super.updateControllers()

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

    case .genesis:
        setupCustomGenesisController()

    default:
        setupStandardController()
    }
}
```

## Step 4: Handle Orientation Changes

Update `viewWillTransition(to:with:)` to recreate N64 controller on rotation:

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    // Temporarily disable video rendering during rotation
    self.emulatorCore?.videoManager.isEnabled = false

    coordinator.animate(alongsideTransition: nil) { _ in
        // Re-enable video rendering
        self.emulatorCore?.videoManager.isEnabled = true

        // Recreate controller for new orientation
        if self.game?.type == .n64 {
            self.setupCustomN64Controller()
        }
    }
}
```

## Step 5: Update viewDidLayoutSubviews()

Ensure menu button stays on top after layout changes:

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Custom game view layout (DON'T call super for this part)
    customLayoutGameViewAndController()

    // Ensure menu button stays on top of custom controllers
    if let menuButton = self.menuButton {
        self.view.bringSubviewToFront(menuButton)
    }
}
```

## Step 6: Test with N64 ROM

Update `Game.swift` to load an N64 ROM for testing:

```swift
// In Game.swift

var type: GameType = .n64  // Change from .gbc to .n64

var fileURL: URL {
    // Update to point to your N64 ROM file
    // Make sure the ROM is added to the Xcode project's Copy Bundle Resources
    guard let url = Bundle.main.url(forResource: "your-n64-game", withExtension: "z64") else {
        fatalError("Could not find N64 ROM file")
    }
    return url
}
```

## Step 7: Verify Build Settings

Ensure the bridge files are included in your Xcode project:

1. Open Xcode project
2. Select `GameEmulator` target
3. Go to "Build Phases" → "Compile Sources"
4. Verify these files are included:
   - N64InputBridge.mm
   - All N64*.swift files

If not, add them manually using the + button.

## Step 8: Build and Run

1. Build the project: `Cmd + B`
2. Run on device or simulator: `Cmd + R`
3. Test all buttons:
   - D-Pad (8 directions)
   - A and B buttons
   - C-button cluster (4 buttons)
   - L and R shoulders
   - Z trigger
   - Start button

## Troubleshooting

### Issue: "Cannot find 'N64InputBridge' in scope"
**Solution:**
- Verify `N64InputBridge.h` is listed in `GameEmulator-Bridging-Header.h`
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`

### Issue: "N64EmulatorBridge not found"
**Solution:**
- Ensure N64DeltaCore framework is linked in Build Phases → Link Binary With Libraries
- Verify N64DeltaCore is in the Cores/ directory
- Check System.swift imports N64DeltaCore

### Issue: Controller appears but buttons don't work
**Solution:**
- Verify button masks in `N64ButtonState.swift` match N64DeltaCore's input values
- Check N64EmulatorBridge has `sharedBridge` method
- Add debug prints in `pressButton` and `releaseButton` methods

### Issue: Layout is wrong after rotation
**Solution:**
- Ensure `viewWillTransition(to:with:)` recreates controller
- Verify orientation detection logic
- Check layout calculations in `N64ControllerLayout.swift`

### Issue: Menu button hidden behind controller
**Solution:**
- Call `self.view.bringSubviewToFront(menuButton)` after controller setup
- Verify z-index in controller view
- Check viewDidLayoutSubviews() implementation

## Testing Checklist

### Basic Functionality
- [ ] D-Pad responds to all 8 directions
- [ ] D-Pad diagonal inputs work (e.g., up+right)
- [ ] A button registers press and release
- [ ] B button registers press and release
- [ ] All 4 C-buttons respond independently
- [ ] L shoulder button works
- [ ] R shoulder button works
- [ ] Z trigger works
- [ ] Start button works

### Visual & UX
- [ ] Button colors match N64 aesthetic (blue A, green B, yellow C)
- [ ] Haptic feedback on button press
- [ ] Button animations smooth (press/release)
- [ ] Touch indicators visible
- [ ] No visual glitches or overlaps

### Layout
- [ ] Landscape layout positions correct
- [ ] Portrait layout positions correct
- [ ] Rotation updates layout smoothly
- [ ] Menu button stays on top
- [ ] All buttons accessible (not cut off)

### Performance
- [ ] No input lag
- [ ] No dropped inputs during rapid presses
- [ ] Smooth gameplay experience
- [ ] No crashes during use
- [ ] Memory usage acceptable

### Integration
- [ ] Controller switches correctly when changing games
- [ ] Previous controller properly cleaned up
- [ ] Standard controller used for non-N64 games
- [ ] External display support (if implemented)

## Advanced: Adding Analog Stick (Future)

The current implementation doesn't include an analog stick due to touch screen limitations. If you want to add one:

1. Create `N64AnalogStickView.swift`
2. Add joystick component (circular touch area with center return)
3. Map X/Y values to analog input range (-80 to +80)
4. Add to layout definitions
5. Implement continuous input (isContinuous = true)

Example structure:
```swift
struct N64AnalogStickView: View {
    @Binding var xValue: CGFloat  // -1.0 to 1.0
    @Binding var yValue: CGFloat  // -1.0 to 1.0
    let onValueChange: (CGFloat, CGFloat) -> Void

    // Implementation with DragGesture
    // Convert touch offset to -80 to +80 range
    // Send to N64InputBridge analog methods
}
```

## Additional Resources

- **Main Documentation:** `N64_CONTROLLER_IMPLEMENTATION.md`
- **GBA Reference:** `GBA_CONTROLLER_IMPLEMENTATION.md`
- **Architecture Guide:** `Generic Controller Architecture.md`
- **Project Guide:** `CLAUDE.md`

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review main implementation documentation
3. Compare with GBA implementation (similar architecture)
4. Verify N64DeltaCore is properly configured

---

**Last Updated:** 2025-10-17
**Compatible With:** iOS 15.0+, Xcode 16.1+
**Framework:** N64DeltaCore (Mupen64Plus)
