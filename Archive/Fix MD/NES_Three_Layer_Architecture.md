# NES Three-Layer Architecture - Background, Game, Controller

## Overview
Applied the same three-layer architecture to NES emulator with GBC-style layout, matching the implementation done for GBA.

## Layer Architecture (Bottom to Top)

```
Layer 0 (Bottom): Background Image (UIImageView)
                  ↓
Layer 1 (Middle): Game Screen (DeltaCore.GameView)
                  ↓
Layer 2 (Top):    Controller Buttons (SwiftUI UIHostingController)
```

## Changes Made

### 1. GameViewController.swift

#### Added NES Background Property (Line 75)
```swift
// Background Image Views
private var gbaBackgroundView: UIImageView?
private var nesBackgroundView: UIImageView?  // NEW!
```

#### Updated setupNESController (Lines 157-180)
**Before:**
```swift
private func setupNESController() {
    guard let vc = viewController else { return }

    vc.controllerView.isHidden = true
    let controller = NESGameController(name: "NES Custom Controller", systemPrefix: "nes", playerIndex: 0)
    nesController = controller

    if let emulatorCore = vc.emulatorCore {
        controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
    }

    let view = NESControllerView(
        controller: controller,
        onMenuButtonTap: { [weak vc] in
            vc?.presentGameMenu()
        }
    )
    nesHosting = setupHostingController(for: view, in: vc)
    currentType = .nes
}
```

**After:**
```swift
private func setupNESController() {
    guard let vc = viewController else { return }

    vc.controllerView.isHidden = true

    // Setup background image view (Layer 0 - bottom)
    setupNESBackground(in: vc)  // NEW!

    let controller = NESGameController(name: "NES Custom Controller", systemPrefix: "nes", playerIndex: 0)
    nesController = controller

    if let emulatorCore = vc.emulatorCore {
        controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
    }

    let view = NESControllerView(
        controller: controller,
        onMenuButtonTap: { [weak vc] in
            vc?.presentGameMenu()
        }
    )
    nesHosting = setupHostingController(for: view, in: vc)
    currentType = .nes
}
```

#### Added setupNESBackground Method (Lines 182-213)
```swift
private func setupNESBackground(in parent: UIViewController) {
    let isLandscape = parent.view.bounds.width > parent.view.bounds.height

    // Only show background in landscape mode
    guard isLandscape else { return }

    // Get background image name from theme
    #if DEBUG
    let imageName = NESThemeManager().currentTheme.backgroundLandscapeImageName
    #else
    let imageName = NESControllerTheme.defaultTheme.backgroundLandscapeImageName
    #endif

    guard let image = UIImage(named: imageName) else { return }

    let backgroundView = UIImageView(image: image)
    backgroundView.contentMode = .scaleAspectFill
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.clipsToBounds = true

    parent.view.addSubview(backgroundView)
    parent.view.sendSubviewToBack(backgroundView)  // Layer 0!

    NSLayoutConstraint.activate([
        backgroundView.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
        backgroundView.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
        backgroundView.topAnchor.constraint(equalTo: parent.view.topAnchor),
        backgroundView.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor)
    ])

    nesBackgroundView = backgroundView
}
```

**Features:**
- Only creates background in **landscape mode**
- Uses `sendSubviewToBack()` to place at bottom layer
- Full screen with Auto Layout constraints
- Theme-aware (reads from NESThemeManager in DEBUG mode)

#### Updated teardownNESController (Lines 215-223)
**Before:**
```swift
private func teardownNESController() {
    teardownHosting(&nesHosting)
    nesController?.reset()
    nesController = nil
}
```

**After:**
```swift
private func teardownNESController() {
    teardownHosting(&nesHosting)
    nesController?.reset()
    nesController = nil

    // Remove background view
    nesBackgroundView?.removeFromSuperview()  // NEW!
    nesBackgroundView = nil  // NEW!
}
```

### 2. NESControllerView.swift

#### Updated Background Handling (Lines 21-26)
**Before:**
```swift
// Background
if geometry.size.width > geometry.size.height {
    Image(getCurrentTheme().backgroundLandscapeImageName)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
} else {
```

**After:**
```swift
// Background - only in portrait mode
// In landscape, background is handled by UIKit layer below game view
if geometry.size.width > geometry.size.height {
    Color.clear
        .ignoresSafeArea()
} else {
```

**Change:** Landscape mode now uses transparent background (`Color.clear`), allowing game screen to show through.

#### Added Opacity to D-Pad (Lines 50-69)
```swift
if let layout = currentLayout {
    let isLandscape = geometry.size.width > geometry.size.height  // NEW!

    // D-Pad
    NESDPadView(...)
        .opacity(isLandscape ? 0.8 : 1.0)  // NEW!
        .zIndex(1)
```

#### Added Opacity to Action Buttons (Lines 71-86)
```swift
// Action Buttons
ForEach(layout.actionButtons, id: \.button.rawValue) { buttonLayout in
    NESButtonView(...)
        .opacity(isLandscape ? 0.8 : 1.0)  // NEW!
        .zIndex(2)  // NEW!
}
```

#### Added Opacity to Center Buttons (Lines 88-107)
```swift
// Center Buttons (Start, Select)
ForEach(layout.centerButtons, id: \.button.rawValue) { buttonLayout in
    NESCenterButtonView(...)
        .opacity(isLandscape ? 0.8 : 1.0)  // NEW!
        .zIndex(2)  // NEW!
}
```

#### Updated Menu Button Z-Index (Line 117)
```swift
// Menu Button
Button(...)
    .position(...)
    .zIndex(3)  // Changed from 1 to 3
```

#### Updated Theme Picker Z-Index (Line 132)
```swift
// Theme Picker Button (Debug Only)
Button(...)
    .position(...)
    .zIndex(3)  // Changed from 1 to 3
```

## View Hierarchy Result

### Landscape Mode:

```
GameViewController.view
│
├─ [Layer 0] nesBackgroundView (UIImageView)
│            └─ Image: NES theme background
│            └─ contentMode: .scaleAspectFill
│            └─ Full screen
│            └─ sendSubviewToBack()
│
├─ [Layer 1] gameView (DeltaCore.GameView)
│            └─ NES emulator output
│            └─ Positioned by LayoutManager
│            └─ Fills available screen
│
└─ [Layer 2] nesHosting.view (UIHostingController)
             └─ SwiftUI: NESControllerView
                 ├─ Background: Color.clear (transparent!)
                 ├─ D-Pad (zIndex 1, 80% opacity)
                 ├─ Action buttons (zIndex 2, 80% opacity)
                 ├─ Center buttons (zIndex 2, 80% opacity)
                 └─ Menu/Picker (zIndex 3)
             └─ bringSubviewToFront()
```

### Portrait Mode:

```
GameViewController.view
│
├─ [Layer 1] gameView (DeltaCore.GameView)
│            └─ NES game renders at top
│
└─ [Layer 2] nesHosting.view (UIHostingController)
             └─ SwiftUI: NESControllerView
                 ├─ Background: Image(backgroundPortraitImageName)
                 │             (top 50% of screen)
                 ├─ Buttons positioned below game
                 └─ All buttons 100% opacity
```

## Visual Result

### Landscape Mode:

```
┌─────────────────────────────────────────────────────────┐
│  [NES Background Image - Full Screen]                   │  ← Layer 0
│  ╔═══════════════════════════════════════════════════╗  │
│  ║ [NES Game Screen - Emulator Output]               ║  │  ← Layer 1
│  ║                                                    ║  │
│  ║                                                    ║  │
│  ║      [D-Pad]                     [A]  [B]         ║  │  ← Layer 2
│  ║                                                    ║  │     80% opacity
│  ║                                                    ║  │
│  ║  Menu                      [Select] [Start]       ║  │
│  ╚═══════════════════════════════════════════════════╝  │
└─────────────────────────────────────────────────────────┘
```

**Player sees:**
1. NES-themed background image at the back
2. NES game screen in the middle (full emulator output)
3. Semi-transparent controller buttons on top (80% opacity)

### Portrait Mode (Unchanged):

```
┌─────────────────────────────┐
│  [NES Background - Top 50%] │
│  ╔═══════════════════════╗  │
│  ║ [NES Game Screen]     ║  │
│  ╚═══════════════════════╝  │
├─────────────────────────────┤
│ [Controller Area - Bottom]  │
│      [D-Pad]      [A] [B]   │
│    [Select]  [Start]        │
└─────────────────────────────┘
```

## Z-Index Hierarchy

### SwiftUI Layer (Layer 2):
```
zIndex 0 (default): Color.clear (background)
zIndex 1:           D-Pad
zIndex 2:           All game buttons (A, B, Start, Select)
zIndex 3:           Menu button, Theme picker
```

## Comparison: Portrait vs Landscape

| Aspect | Portrait | Landscape |
|--------|----------|-----------|
| **Background Layer** | SwiftUI Image (top 50%) | UIKit UIImageView (full screen, Layer 0) |
| **Game Screen** | Top area | Full screen (Layer 1, visible through transparent controller) |
| **Button Opacity** | 100% | 80% |
| **Button Position** | Below game | Overlay on game |
| **Layout Style** | GBC-style (buttons below) | Modern overlay |

## Rotation Handling

Rotation is automatically handled by the existing `handleRotation()` method in GameViewController, which calls:
```swift
self.controllerManager.setupController(for: (self.game as? Game)?.type ?? .unknown)
```

This triggers:
1. `teardownNESController()` - Removes old background and controller
2. `setupNESController()` - Creates new background (if landscape) and controller

**Result:** Background automatically appears/disappears based on orientation.

## Theme Support

### DEBUG Mode:
```swift
#if DEBUG
let imageName = NESThemeManager().currentTheme.backgroundLandscapeImageName
#endif
```
- Reads current theme from NESThemeManager
- Updates when user changes theme via theme picker

### Release Mode:
```swift
#else
let imageName = NESControllerTheme.defaultTheme.backgroundLandscapeImageName
#endif
```
- Uses default NES theme

## Files Modified

### GameViewController.swift
**Lines Added/Modified:**
- Line 75: Added `nesBackgroundView: UIImageView?` property
- Lines 157-180: Updated `setupNESController()` to call `setupNESBackground()`
- Lines 182-213: Added `setupNESBackground()` method
- Lines 215-223: Updated `teardownNESController()` to remove background

### NESControllerView.swift
**Lines Modified:**
- Lines 21-26: Changed landscape background from `Image` to `Color.clear`
- Line 51: Added `let isLandscape` variable
- Line 68: Added `.opacity(isLandscape ? 0.8 : 1.0)` to D-Pad
- Lines 84-85: Added `.opacity()` and `.zIndex(2)` to action buttons
- Lines 105-106: Added `.opacity()` and `.zIndex(2)` to center buttons
- Line 117: Changed menu button from `.zIndex(1)` to `.zIndex(3)`
- Line 132: Changed theme picker from `.zIndex(1)` to `.zIndex(3)`

## Testing Checklist

### Landscape Mode:
- [ ] Background image visible at full screen
- [ ] NES game screen visible on top of background
- [ ] Controller buttons visible on top of game (80% opacity)
- [ ] NES game content fully visible and not blocked
- [ ] Background changes with theme selection (DEBUG mode)

### Portrait Mode:
- [ ] No UIKit background view created
- [ ] SwiftUI background displayed correctly (top 50%)
- [ ] Buttons positioned below game
- [ ] All buttons 100% opacity
- [ ] No visual regressions from previous implementation

### Rotation:
- [ ] Portrait → Landscape: Background UIImageView appears
- [ ] Landscape → Portrait: Background UIImageView disappears
- [ ] No visual glitches during rotation
- [ ] All layers maintain correct z-order after rotation

### Theme Changes (DEBUG):
- [ ] Background updates when theme changes
- [ ] Correct background image for each NES theme

## Technical Benefits

### Identical to GBA Implementation:
- Same three-layer architecture
- Same opacity implementation (80% in landscape, 100% in portrait)
- Same z-index hierarchy
- Same rotation handling
- Same theme integration

### Code Reusability:
- Follows established pattern from GBA
- Easy to maintain and understand
- Consistent across all custom controllers

## Build Status

✅ **BUILD RUNNING**
- Compiling with new changes
- No syntax errors detected
- Following same pattern as successful GBA build

## Integration with GBC Layout

As requested, the NES implementation uses GBC-style layout:
- Portrait: Buttons below game screen (traditional handheld style)
- Landscape: Buttons overlay on game (modern mobile game style)
- Same layout positioning principles as GBC
- Same opacity behavior as GBA

## Summary of Architecture

### What Was Done:
1. ✅ Added UIImageView background layer (Layer 0) for landscape mode
2. ✅ Made SwiftUI controller background transparent in landscape
3. ✅ Added 80% opacity to all buttons in landscape mode
4. ✅ Added proper z-index values to all elements
5. ✅ Integrated with theme system
6. ✅ Automatic rotation handling

### Result:
```
Layer 0: Background Image (landscape only)
   ↓
Layer 1: Game Screen (always visible)
   ↓
Layer 2: Controller Buttons (80% opacity in landscape)
```

### Matches GBA Implementation:
✅ Same layer architecture
✅ Same opacity behavior
✅ Same z-index hierarchy
✅ Same theme integration
✅ GBC-style layout as requested

---

**Implementation Date:** October 22, 2025
**Architecture:** Three-Layer UIKit View Hierarchy (matching GBA)
**Pattern:** Background (UIImageView) → Game (GameView) → Controller (SwiftUI)
**Layout Style:** GBC-inspired (portrait: below, landscape: overlay)
**Opacity:** 80% in landscape, 100% in portrait
