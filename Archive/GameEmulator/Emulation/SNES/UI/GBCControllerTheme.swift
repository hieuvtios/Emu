//
//  GBCControllerTheme.swift
//  GameEmulator
//
//  Created by Hieu Vu on 10/13/25.
//


//
//  GBCControllerTheme.swift
//  GameEmulator
//
//  Theme configuration for GBC controller appearance
//

import Foundation

struct SNESControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let dpadImageName: String
    let buttonAImageName: String
    let buttonBImageName: String
    let startButtonImageName: String
    let selectButtonImageName: String
    let menuButtonImageName: String
    let backgroundPortraitImageName: String
    let backgroundLandscapeImageName: String

    // MARK: - Theme Presets

    static let defaultTheme = SNESControllerTheme(
        id: "default",
        name: "Theme 1",
        dpadImageName: "btn-dpad",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba",
        selectButtonImageName: "btn-select-gba",
        menuButtonImageName: "btn-menu-gba",
        backgroundPortraitImageName: "bg1",
        backgroundLandscapeImageName: "bg1"
    )

    static let theme2 = SNESControllerTheme(
        id: "theme2",
        name: "Theme 2",
        dpadImageName: "btn-dpad-2",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba-2",
        selectButtonImageName: "btn-select-gba-2",
        menuButtonImageName: "btn-menu-gba-2",
        backgroundPortraitImageName: "bg2",
        backgroundLandscapeImageName: "bg2"
    )

    static let theme3 = SNESControllerTheme(
        id: "theme3",
        name: "Theme 3",
        dpadImageName: "btn-dpad-3",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba-3",
        selectButtonImageName: "btn-select-gba-3",
        menuButtonImageName: "btn-menu-gba-3",
        backgroundPortraitImageName: "bg3",
        backgroundLandscapeImageName: "bg3"
    )

    static let theme4 = SNESControllerTheme(
        id: "theme4",
        name: "Theme 4",
        dpadImageName: "btn-dpad-4",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba-4",
        selectButtonImageName: "btn-select-gba-4",
        menuButtonImageName: "btn-menu-gba-4",
        backgroundPortraitImageName: "bg4",
        backgroundLandscapeImageName: "bg4"
    )

    static let theme5 = SNESControllerTheme(
        id: "theme5",
        name: "Theme 5",
        dpadImageName: "btn-dpad-5",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        startButtonImageName: "btn-start-gba-5",
        selectButtonImageName: "btn-select-gba-5",
        menuButtonImageName: "btn-menu-gba-5",
        backgroundPortraitImageName: "bg5",
        backgroundLandscapeImageName: "bg5"
    )



    
    // MARK: - All Available Themes

    static let allThemes: [SNESControllerTheme] = [
        defaultTheme,
        theme2,
        theme3,
        theme4,
        theme5,
    ]
}
