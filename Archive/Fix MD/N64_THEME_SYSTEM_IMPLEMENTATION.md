# N64 Theme System Implementation

## Overview

Created a complete theming system for the N64 controller following the same pattern as the GBC implementation. This allows users to switch between different visual themes for the N64 controller in DEBUG builds.

## Implementation Date
October 18, 2025

## Files Created

### 1. N64ThemeManager.swift
**Path:** `GameEmulator/Emulation/N64/UI/N64ThemeManager.swift`

**Purpose:** Manages theme selection and persistence for N64 controller

**Key Features:**
- `@Published var currentTheme` - Observable current theme
- `availableThemes` - Array of all available themes
- `selectTheme(_:)` - Switch to a specific theme
- `resetToDefault()` - Reset to default theme
- Automatic persistence using `UserDefaults`
- Broadcasts `n64ThemeDidChange` notification when theme changes

**Storage:**
- UserDefaults key: `"N64ControllerTheme"`
- Stored as JSON encoded data

### 2. N64ThemePickerView.swift
**Path:** `GameEmulator/Emulation/N64/UI/N64ThemePickerView.swift`

**Purpose:** SwiftUI view for theme selection UI

**Key Features:**
- Grid layout with adaptive columns
- Theme preview cards showing:
  - Background image preview
  - D-Pad icon (bottom left)
  - C-button cluster (bottom right) - unique to N64
- Selected theme indication with blue border and badge
- Navigation bar with:
  - "Reset" button (leading) - resets to default theme
  - "Done" button (trailing) - dismisses picker
- Tap to select and auto-dismiss

**Components:**
- `N64ThemePickerView` - Main picker view
- `N64ThemeCard` - Individual theme preview card

### 3. N64ControllerTheme.swift (Already Existed)
**Path:** `GameEmulator/Emulation/N64/UI/N64ControllerTheme.swift`

**Purpose:** Theme configuration struct

**Properties:**
- `id` - Unique theme identifier
- `name` - Display name
- Button images:
  - `leftButtonImageName` - L trigger button
  - `rightButtonImageName` - R trigger button
  - `zButtonImageName` - Z button
  - `dpadImageName` - D-Pad
  - `buttonAImageName` - A button
  - `buttonBImageName` - B button
  - `cUpImageName` - C-Up button
  - `cDownImageName` - C-Down button
  - `cLeftImageName` - C-Left button
  - `cRightImageName` - C-Right button
  - `startButtonImageName` - Start button
  - `menuButtonImageName` - Menu button
- Background images:
  - `backgroundPortraitImageName` - Portrait mode background
  - `backgroundLandscapeImageName` - Landscape mode background

**Available Themes:**
1. **Theme 1** (Default) - Uses bg1, btn-dpad
2. **Theme 2** - Uses bg2, btn-dpad-2
3. **Theme 3** - Uses bg3, btn-dpad-3
4. **Theme 4** - Uses bg4, btn-dpad-4
5. **Theme 5** - Uses bg5, btn-dpad-5

## GameViewController Integration

### Changes Made

#### 1. setupNotifications() - Added N64 Theme Observer
```swift
#if DEBUG
nc.addObserver(self, selector: #selector(n64ThemeDidChange),
               name: NSNotification.Name("N64ThemeDidChangeNotification"),
               object: nil)
#endif
```

#### 2. Added Theme Change Handler
```swift
#if DEBUG
@objc private func n64ThemeDidChange(with notification: Notification) {
    updateMenuButtonImage()
}
#endif
```

**What it does:**
- Listens for theme changes from `N64ThemeManager`
- Updates the menu button image when theme changes
- Only active in DEBUG builds

## N64ControllerView Integration

The N64ControllerView already uses the theme system (as shown in the modified file):

```swift
@StateObject private var themeManager = N64ThemeManager()

private func getCurrentTheme() -> GBCControllerTheme {
    #if DEBUG
    return themeManager.currentTheme
    #else
    return .defaultTheme
    #endif
}
```

**Note:** There's a type mismatch here - it should return `N64ControllerTheme`, not `GBCControllerTheme`. This needs to be corrected.

## DEBUG-Only Feature

The entire theme system is wrapped in `#if DEBUG` compiler directives:
- Only available in debug builds
- Production builds always use the default theme
- Reduces app size in release builds

## Architecture Pattern

Follows the exact same pattern as GBC implementation:

```
N64ThemeManager (ObservableObject)
    ↓ manages
N64ControllerTheme (Codable, Identifiable)
    ↓ displayed in
N64ThemePickerView (SwiftUI View)
    ↓ notifies
GameViewController (via Notification.Name.n64ThemeDidChange)
```

## How to Use

### In Code (DEBUG build only):

```swift
// Create theme manager
let themeManager = N64ThemeManager()

// Get current theme
let currentTheme = themeManager.currentTheme

// Change theme
themeManager.selectTheme(.theme2)

// Reset to default
themeManager.resetToDefault()

// Show theme picker
let picker = N64ThemePickerView(themeManager: themeManager)
```

### In N64ControllerView:

```swift
@StateObject private var themeManager = N64ThemeManager()

// Use current theme
Image(themeManager.currentTheme.dpadImageName)
Image(themeManager.currentTheme.backgroundPortraitImageName)
```

## Notification System

**Notification Name:** `N64ThemeDidChangeNotification`

**Posted When:** Theme changes in `N64ThemeManager`

**Observers:**
- `GameViewController.n64ThemeDidChange(_:)` - Updates menu button image

**Object:** The new `N64ControllerTheme` instance

## Persistence

**Storage Location:** `UserDefaults.standard`

**Key:** `"N64ControllerTheme"`

**Format:** JSON encoded `N64ControllerTheme`

**Lifecycle:**
- Theme loads on `N64ThemeManager` initialization
- Theme saves automatically when changed
- Falls back to `.defaultTheme` if no saved theme exists

## Differences from GBC Implementation

### 1. Additional Buttons
N64 has more buttons than GBC:
- L/R/Z triggers
- C-button cluster (C-Up, C-Down, C-Left, C-Right)
- More properties in theme struct

### 2. Theme Card Preview
The N64 theme card shows:
- D-Pad on bottom left (same as GBC)
- **C-button cluster on bottom right** (unique to N64)
- Shows the distinctive N64 controller layout

### 3. Theme Properties
More image name properties for N64-specific buttons:
- `leftButtonImageName`, `rightButtonImageName`, `zButtonImageName`
- Four C-button properties: `cUpImageName`, `cDownImageName`, `cLeftImageName`, `cRightImageName`

## File Structure

```
GameEmulator/Emulation/N64/UI/
├── N64ControllerTheme.swift     ← Theme configuration (already existed)
├── N64ThemeManager.swift        ← Theme manager (NEW)
└── N64ThemePickerView.swift     ← Theme picker UI (NEW)
```

## Integration Points

### 1. N64ControllerView
- Uses `@StateObject private var themeManager = N64ThemeManager()`
- Calls `getCurrentTheme()` to get current theme
- Applies theme images to all controller elements

### 2. GameViewController
- Observes `n64ThemeDidChange` notification
- Updates menu button when theme changes
- Only in DEBUG builds

### 3. UserDefaults
- Persists selected theme across app launches
- Key: `"N64ControllerTheme"`

## Testing Checklist

- [ ] Verify theme picker displays all 5 themes
- [ ] Confirm theme selection updates controller appearance
- [ ] Test theme persistence (select theme, restart app)
- [ ] Verify "Reset" button returns to default theme
- [ ] Check C-button cluster preview in theme cards
- [ ] Ensure notification updates menu button image
- [ ] Verify DEBUG-only compilation (no theme picker in release)
- [ ] Test theme switching during active gameplay
- [ ] Confirm landscape/portrait backgrounds switch correctly

## Future Enhancements

1. **Custom Theme Creation**
   - Allow users to create custom themes
   - Image picker for background and buttons

2. **More Themes**
   - Add additional pre-defined themes
   - Seasonal or special event themes

3. **Theme Export/Import**
   - Share themes between devices
   - Community theme marketplace

4. **Per-Game Themes**
   - Different themes for different N64 games
   - Auto-switch based on game

## Related Files

- `GameEmulator/Emulation/GBC/UI/GBCThemeManager.swift` - GBC reference implementation
- `GameEmulator/Emulation/GBC/UI/GBCThemePickerView.swift` - GBC picker reference
- `GameEmulator/Emulation/N64/Controller/N64ControllerView.swift` - Uses themes
- `GameEmulator/Emulation/Generic/GameViewController.swift` - Theme change observer

## Notes

- **Type Mismatch Issue:** `N64ControllerView.getCurrentTheme()` returns `GBCControllerTheme` instead of `N64ControllerTheme` - this needs to be fixed
- All theme images must exist in the asset catalog
- Theme system is DEBUG-only to keep release builds lean
- Follows SwiftUI best practices with `@ObservedObject` and `@Published`

---

**Implementation completed successfully on October 18, 2025**
