# N64 Controller Architecture Diagram

## Component Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                      GameViewController                          │
│  - Manages game lifecycle and controller switching              │
│  - Properties: customN64Controller, n64HostingController        │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ creates & manages
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              UIHostingController<N64ControllerView>             │
│  - Wraps SwiftUI view in UIKit container                        │
│  - Handles view lifecycle                                       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ hosts
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     N64ControllerView                            │
│  - Main SwiftUI container view                                  │
│  - Manages component layout and z-ordering                      │
│  - State: buttonStates, dpadButtons, cButtons                   │
└──┬───────┬──────────┬──────────┬──────────┬──────────┬─────────┘
   │       │          │          │          │          │
   │       │          │          │          │          │
   ▼       ▼          ▼          ▼          ▼          ▼
┌────┐ ┌──────┐ ┌──────────┐ ┌──────┐ ┌──────┐ ┌──────────┐
│ D- │ │ A/B  │ │ C-Button │ │ L/R  │ │  Z   │ │  Start   │
│Pad │ │Buttons│ │ Cluster  │ │Shoulder│Button│ │  Button  │
└─┬──┘ └───┬──┘ └────┬─────┘ └───┬──┘ └───┬──┘ └────┬─────┘
  │        │         │           │        │         │
  │        │         │           │        │         │
  └────────┴─────────┴───────────┴────────┴─────────┘
                      │
                      │ all send input to
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    N64DirectController                           │
│  - Swift wrapper for input bridge                               │
│  - Methods: pressButton(), releaseButton(), reset()             │
│  - Player index management                                      │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ uses
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      N64InputBridge (ObjC++)                     │
│  - Thread-safe singleton with os_unfair_lock                    │
│  - Bridge between Swift and C++                                 │
│  - Methods: pressButton, releaseButton, resetAllInputs          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ calls
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│            N64EmulatorBridge (N64DeltaCore)                     │
│  - Shared bridge from N64DeltaCore framework                    │
│  - Methods: activateInput, deactivateInput, resetInputs         │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ sends to
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Mupen64Plus Core (C++)                        │
│  - Native N64 emulator engine                                   │
│  - Processes button inputs and runs game                        │
└─────────────────────────────────────────────────────────────────┘
```

## Input Flow Diagram

```
User Touch Event
       │
       ▼
┌─────────────────┐
│  SwiftUI Gesture │ (DragGesture on button)
│    Detection     │
└────────┬─────────┘
         │
         ▼
┌─────────────────┐
│ Button Component │ (N64ButtonView, N64DPadView, etc.)
│   onPress() /    │
│  onRelease()     │
└────────┬─────────┘
         │
         ▼
┌─────────────────┐
│N64ControllerView │ Closure call with button type
│  State Update    │
└────────┬─────────┘
         │
         ▼
┌─────────────────┐
│N64DirectController│ pressButton(.a) / releaseButton(.a)
│  Button Method   │
└────────┬─────────┘
         │
         ▼
┌─────────────────┐
│ N64InputBridge  │ pressButton(128, forPlayer: 0)
│  (Objective-C++) │ [with button mask]
└────────┬─────────┘
         │
         │ Thread-safe lock
         ▼
┌─────────────────┐
│N64EmulatorBridge│ activateInput(128, value: 1.0, playerIndex: 0)
│ (DeltaCore)     │
└────────┬─────────┘
         │
         ▼
┌─────────────────┐
│ Mupen64Plus Core│ Button registered in emulator
│    (C++ Core)   │
└─────────────────┘
         │
         ▼
    Game Response
```

## Component Relationships

### UI Layer (SwiftUI)
```
N64ControllerView
├── N64DPadView
│   └── DPadShape (custom Shape)
├── N64ButtonView (A, B)
│   └── Circle with gesture
├── N64CButtonView
│   ├── C-Up button
│   ├── C-Down button
│   ├── C-Left button
│   └── C-Right button
├── N64ShoulderButtonView (L, R)
│   └── RoundedRectangle with gesture
├── N64ZButtonView
│   └── Smaller RoundedRectangle
└── N64StartButtonView
    └── Capsule with gesture
```

### Controller Layer (Swift)
```
N64DirectController
├── name: String
├── playerIndex: Int
└── inputBridge: N64InputBridge
```

### Bridge Layer (Objective-C++)
```
N64InputBridge
├── + shared() → Singleton
├── - pressButton:forPlayer:
├── - releaseButton:forPlayer:
└── - resetAllInputs
```

### Data Layer (Swift)
```
N64ButtonState.swift
├── N64ButtonType (enum)
│   ├── displayName
│   ├── buttonMask
│   ├── gameInput
│   └── controllerInput
├── N64ControllerInput (struct)
│   └── Input protocol conformance
└── N64ButtonStateTracker (struct)
    ├── press(_:)
    ├── release(_:)
    └── isPressed(_:)
```

### Layout Layer (SwiftUI)
```
N64ControllerLayout
├── LayoutMode (enum)
│   ├── landscape
│   └── portrait
├── ButtonLayout (struct)
│   ├── position: CGPoint
│   ├── size: CGSize
│   └── button: N64ButtonType
├── DPadLayout (struct)
│   ├── center: CGPoint
│   └── radius: CGFloat
├── CButtonLayout (struct)
│   ├── center: CGPoint
│   ├── buttonSize: CGSize
│   └── spacing: CGFloat
└── N64ControllerLayoutDefinition
    ├── mode
    ├── dpad
    ├── actionButtons
    ├── cButtonCluster
    ├── shoulderButtons
    ├── zButton
    └── startButton
```

## State Management Flow

```
User Press
    │
    ▼
@State buttonStates[.a] = true
    │
    ▼
Binding updates view
    │
    ▼
Button visual feedback (scale, color, shadow)
    │
    └──> Haptic feedback (UIImpactFeedbackGenerator)
    │
    ▼
controller.pressButton(.a)
    │
    ▼
Input sent to emulator
    │
    ▼
User Release
    │
    ▼
@State buttonStates[.a] = false
    │
    ▼
controller.releaseButton(.a)
```

## Thread Safety

```
Swift Thread (Main/UI)
       │
       │ controller.pressButton(.a)
       ▼
Objective-C++ Thread (Any)
       │
       │ os_unfair_lock_lock(&_lock)
       ▼
Protected Section
       │
       │ [N64EmulatorBridge activateInput:...]
       ▼
Emulator Thread (C++)
       │
       │ os_unfair_lock_unlock(&_lock)
       ▼
Swift Thread Returns
```

## Memory Management

```
GameViewController
    │ (strong reference)
    ▼
UIHostingController<N64ControllerView>
    │ (view contains)
    ▼
N64ControllerView
    │ (captures)
    ▼
N64DirectController
    │ (uses)
    ▼
N64InputBridge (Singleton)
    │ (calls)
    ▼
N64EmulatorBridge (Singleton from framework)

Cleanup on teardown:
1. n64HostingController.removeFromParent()
2. customN64Controller.reset()
3. customN64Controller = nil
4. Bridges remain (singletons)
```

## Button Mask Mapping

```
N64ButtonType          Button Mask    Mupen64Plus Constant
─────────────────────  ────────────   ─────────────────────
.up                    2048           R_DPAD_U
.down                  4096           R_DPAD_D
.left                  512            R_DPAD_L
.right                 1024           R_DPAD_R
.a                     128            A_BUTTON
.b                     64             B_BUTTON
.cUp                   8              R_CBUTTON_U
.cDown                 4              R_CBUTTON_D
.cLeft                 2              R_CBUTTON_L
.cRight                1              R_CBUTTON_R
.l                     32             L_TRIG
.r                     16             R_TRIG
.z                     8192           Z_TRIG
.start                 256            START_BUTTON
```

## Layout Positioning Logic

### Landscape Mode (844 x 390)
```
┌─────────────────────────────────────────────────┐
│  [L]              [Start]            [R]        │
│  [Z]                                            │
│                                                  │
│  (D-Pad)                         [C↑]           │
│    •                           [C←]•[C→]        │
│                                  [C↓]           │
│                                                  │
│                               [B] [A]           │
└─────────────────────────────────────────────────┘
```

### Portrait Mode (393 x 852)
```
┌─────────────────────┐
│                     │
│    Game View        │
│    (Top Area)       │
│                     │
│─────────────────────│
│   [L]       [R]     │
│   [Z]               │
│                     │
│            [C↑]     │
│          [C←]•[C→]  │
│            [C↓]     │
│                     │
│  (D-Pad)            │
│    •         [B][A] │
│                     │
│      [Start]        │
└─────────────────────┘
```

## Color Scheme

```
Button      Base Color              Pressed Color
─────────── ─────────────────────── ───────────────────────
A           Blue (0.2, 0.4, 0.9)    Bright Blue (0.9α)
B           Green (0.2, 0.8, 0.3)   Bright Green (0.9α)
C-Buttons   Yellow (1.0, 0.85, 0.0) Bright Yellow (0.9α)
L/R         Gray (0.6α)             Dark Gray (0.9α)
Z           Dark Gray (0.3, 0.7α)   Darker Gray (0.9α)
Start       Red (0.6α)              Bright Red (0.8α)
D-Pad       Gray (0.6α)             Gray (0.6α)
```

## Z-Index Layering

```
Layer 4: Start Button (top)
Layer 3: Shoulder Buttons (L, R, Z)
Layer 2: Action Buttons (A, B, C-cluster)
Layer 1: D-Pad
Layer 0: Background
```

## File Dependencies

```
N64ControllerView.swift
├── imports N64DirectController
├── imports N64ControllerLayout
├── imports N64ButtonView
├── imports N64DPadView
├── imports N64CButtonView
└── imports N64ButtonState (for ButtonType)

N64DirectController.swift
├── imports N64InputBridge (via bridging header)
└── imports N64ButtonState

N64ButtonView.swift
└── imports N64ButtonState

N64DPadView.swift
└── imports N64ButtonState

N64CButtonView.swift
└── imports N64ButtonState

N64ControllerLayout.swift
└── imports N64ButtonState

N64ButtonState.swift
├── imports DeltaCore
└── imports N64DeltaCore

N64InputBridge.mm
└── imports N64DeltaCore/N64EmulatorBridge.h
```

## Build Dependencies

```
GameEmulator Target
├── Links: N64DeltaCore.framework
├── Embeds: N64DeltaCore.framework
├── Bridging Header: GameEmulator-Bridging-Header.h
│   └── Imports: N64InputBridge.h
└── Compile Sources:
    ├── N64InputBridge.mm (Objective-C++)
    ├── N64ButtonState.swift
    ├── N64DirectController.swift
    ├── N64ControllerLayout.swift
    ├── N64ButtonView.swift
    ├── N64DPadView.swift
    ├── N64CButtonView.swift
    └── N64ControllerView.swift
```

---

**Visual Reference Version:** 1.0
**Created:** 2025-10-17
**Architecture:** Direct Bridge Pattern
