//
//  GenesisControllerTheme.swift
//  GameEmulator
//
//  Theme configuration for Genesis controller appearance
//

import Foundation

/// Represents a visual theme for the Sega Genesis controller layout.
struct GenesisControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let dpadImageName: String
    let buttonAImageName: String
    let buttonBImageName: String
    let buttonXImageName: String
    let buttonYImageName: String
    let buttonZImageName: String
    let buttonCImageName: String
    let startButtonImageName: String
    let selectButtonImageName: String
    let menuButtonImageName: String
    let backgroundPortraitImageName: String
    let backgroundLandscapeImageName: String

    // MARK: - Theme Presets

    static let defaultTheme = GenesisControllerTheme(
        id: "default",
        name: "Theme 1",
        dpadImageName: "dpad_genesis",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        buttonXImageName: "btn_genesis_x",
        buttonYImageName: "btn_genesis_y",
        buttonZImageName: "btn_genesis_z",
        buttonCImageName: "btn_genesis_c",
        startButtonImageName: "btn_genesis_start",
        selectButtonImageName: "btn-select-gba",
        menuButtonImageName: "btn_genesis_menu",
        backgroundPortraitImageName: "bg1",
        backgroundLandscapeImageName: "bg1"
    )

    static let theme2 = GenesisControllerTheme(
        id: "theme2",
        name: "Theme 2",
        dpadImageName: "dpad_genesis-2",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        buttonXImageName: "btn_genesis_x",
        buttonYImageName: "btn_genesis_y",
        buttonZImageName: "btn_genesis_z",
        buttonCImageName: "btn_genesis_c",
        startButtonImageName: "btn_genesis_start",
        selectButtonImageName: "btn-select-gba-2",
        menuButtonImageName: "btn_genesis_menu",
        backgroundPortraitImageName: "bg2",
        backgroundLandscapeImageName: "bg2"
    )

    static let theme3 = GenesisControllerTheme(
        id: "theme3",
        name: "Theme 3",
        dpadImageName: "dpad_genesis-3",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        buttonXImageName: "btn_genesis_x",
        buttonYImageName: "btn_genesis_y",
        buttonZImageName: "btn_genesis_z",
        buttonCImageName: "btn_genesis_c",
        startButtonImageName: "btn_genesis_start",
        selectButtonImageName: "btn-select-gba-3",
        menuButtonImageName: "btn_genesis_menu",
        backgroundPortraitImageName: "bg3",
        backgroundLandscapeImageName: "bg3"
    )

    static let theme4 = GenesisControllerTheme(
        id: "theme4",
        name: "Theme 4",
        dpadImageName: "dpad_genesis-4",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        buttonXImageName: "btn_genesis_x",
        buttonYImageName: "btn_genesis_y",
        buttonZImageName: "btn_genesis_z",
        buttonCImageName: "btn_genesis_c",
        startButtonImageName: "btn_genesis_start",
        selectButtonImageName: "btn-select-gba-4",
        menuButtonImageName: "btn_genesis_menu",
        backgroundPortraitImageName: "bg4",
        backgroundLandscapeImageName: "bg4"
    )

    static let theme5 = GenesisControllerTheme(
        id: "theme5",
        name: "Theme 5",
        dpadImageName: "dpad_genesis-5",
        buttonAImageName: "button-a-gba",
        buttonBImageName: "button-b-gba",
        buttonXImageName: "btn_genesis_x",
        buttonYImageName: "btn_genesis_y",
        buttonZImageName: "btn_genesis_z",
        buttonCImageName: "btn_genesis_c",
        startButtonImageName: "btn_genesis_start",
        selectButtonImageName: "btn-select-gba-5",
        menuButtonImageName: "btn_genesis_menu",
        backgroundPortraitImageName: "bg5",
        backgroundLandscapeImageName: "bg5"
    )

    // MARK: - All Available Themes

    static let allThemes: [GenesisControllerTheme] = [
        defaultTheme,
        theme2,
        theme3,
        theme4,
        theme5
    ]
}
