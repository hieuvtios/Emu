//
//  GBCControllerTheme.swift
//  GameEmulator
//
//  Theme configuration for GBC controller appearance
//

import Foundation

struct GBCControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let dpadImageName: String
    let buttonAImageName: String
    let buttonBImageName: String
    let startButtonImageName: String
    let selectButtonImageName: String
    let backgroundPortraitImageName: String
    let backgroundLandscapeImageName: String

    // MARK: - Theme Presets

    static let defaultTheme = GBCControllerTheme(
        id: "default",
        name: "Theme 1",
        dpadImageName: "btn-dpad",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg 1",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme2 = GBCControllerTheme(
        id: "theme2",
        name: "Theme 2",
        dpadImageName: "btn-dpad-2",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg2",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme3 = GBCControllerTheme(
        id: "theme3",
        name: "Theme 3",
        dpadImageName: "btn-dpad-3",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg3",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme4 = GBCControllerTheme(
        id: "theme4",
        name: "Theme 4",
        dpadImageName: "btn-dpad-4",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg4",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme5 = GBCControllerTheme(
        id: "theme5",
        name: "Theme 5",
        dpadImageName: "btn-dpad-5",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg5",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme6 = GBCControllerTheme(
        id: "theme6",
        name: "Theme 6",
        dpadImageName: "btn-dpad-6",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba-6",
        selectButtonImageName: "btn-select-gba-6",
        backgroundPortraitImageName: "bg6",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme7 = GBCControllerTheme(
        id: "theme7",
        name: "Theme 7",
        dpadImageName: "btn-dpad",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg7",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme8 = GBCControllerTheme(
        id: "theme8",
        name: "Theme 8",
        dpadImageName: "btn-dpad-2",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg8",
        backgroundLandscapeImageName: "bg_landscape"
    )

    static let theme9 = GBCControllerTheme(
        id: "theme9",
        name: "Theme 9",
        dpadImageName: "btn-dpad-3",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        backgroundPortraitImageName: "bg9",
        backgroundLandscapeImageName: "bg_landscape"
    )

    // MARK: - All Available Themes

    static let allThemes: [GBCControllerTheme] = [
        defaultTheme,
        theme2,
        theme3,
        theme4,
        theme5,
        theme6,
        theme7,
        theme8,
        theme9
    ]
}
