//
//  N64ControllerTheme.swift
//  GameEmulator
//
//  Theme configuration for N64 controller appearance
//

import Foundation

struct N64ControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let leftButtonImageName: String
    let rightButtonImageName: String
    let zButtonImageName: String
    let zButtonImageGreenName: String
    let dpadImageName: String
    let buttonAImageName: String
    let buttonBImageName: String
    let cUpImageName: String
    let cDownImageName: String
    let cLeftImageName: String
    let cRightImageName: String
    let startButtonImageName: String
    let menuButtonImageName: String
    let analogStickBaseImageName: String
    let analogStickThumbImageName: String
    let backgroundPortraitImageName: String
    let backgroundLandscapeImageName: String

    // MARK: - Theme Presets

    static let defaultTheme = N64ControllerTheme(
        id: "default",
        name: "Theme 1",
        leftButtonImageName: "btn_n64_l",
        rightButtonImageName: "btn_n64_r",
        zButtonImageName: "btn_n64_z",
        zButtonImageGreenName: "btn_n64_z_blue",
        dpadImageName: "btn-dpad",
        buttonAImageName: "btn_n64_a",
        buttonBImageName: "btn_n64_b",
        cUpImageName: "btn_n64_c_up",
        cDownImageName: "btn_n64_c_down",
        cLeftImageName: "btn_n64_c_left",
        cRightImageName: "btn_n64_c_right",
        startButtonImageName: "btn_n64_start",
        menuButtonImageName: "btn_n64_menu",
        analogStickBaseImageName: "btn_n64_analog_base",
        analogStickThumbImageName: "btn_n64_analog_thumb",
        backgroundPortraitImageName: "bg1",
        backgroundLandscapeImageName: "bg1"
    )

    static let theme2 = N64ControllerTheme(
        id: "theme2",
        name: "Theme 2",
        leftButtonImageName: "btn_n64_l",
        rightButtonImageName: "btn_n64_r",
        zButtonImageName: "btn_n64_z",
        zButtonImageGreenName: "btn_n64_z_blue",
        dpadImageName: "btn-dpad-2",
        buttonAImageName: "btn_n64_a",
        buttonBImageName: "btn_n64_b",
        cUpImageName: "btn_n64_c_up",
        cDownImageName: "btn_n64_c_down",
        cLeftImageName: "btn_n64_c_left",
        cRightImageName: "btn_n64_c_right",
        startButtonImageName: "btn_n64_start",
        menuButtonImageName: "btn_n64_menu",
        analogStickBaseImageName: "btn_n64_analog_base",
        analogStickThumbImageName: "btn_n64_analog_thumb",
        backgroundPortraitImageName: "bg2",
        backgroundLandscapeImageName: "bg2"
    )

    static let theme3 = N64ControllerTheme(
        id: "theme3",
        name: "Theme 3",
        leftButtonImageName: "btn_n64_l",
        rightButtonImageName: "btn_n64_r",
        zButtonImageName: "btn_n64_z",
        zButtonImageGreenName: "btn_n64_z_blue",
        dpadImageName: "btn-dpad-3",
        buttonAImageName: "btn_n64_a",
        buttonBImageName: "btn_n64_b",
        cUpImageName: "btn_n64_c_up",
        cDownImageName: "btn_n64_c_down",
        cLeftImageName: "btn_n64_c_left",
        cRightImageName: "btn_n64_c_right",
        startButtonImageName: "btn_n64_start",
        menuButtonImageName: "btn_n64_menu",
        analogStickBaseImageName: "btn_n64_analog_base",
        analogStickThumbImageName: "btn_n64_analog_thumb",
        backgroundPortraitImageName: "bg3",
        backgroundLandscapeImageName: "bg3"
    )

    static let theme4 = N64ControllerTheme(
        id: "theme4",
        name: "Theme 4",
        leftButtonImageName: "btn_n64_l",
        rightButtonImageName: "btn_n64_r",
        zButtonImageName: "btn_n64_z",
        zButtonImageGreenName: "btn_n64_z_blue",
        dpadImageName: "btn-dpad-4",
        buttonAImageName: "btn_n64_a",
        buttonBImageName: "btn_n64_b",
        cUpImageName: "btn_n64_c_up",
        cDownImageName: "btn_n64_c_down",
        cLeftImageName: "btn_n64_c_left",
        cRightImageName: "btn_n64_c_right",
        startButtonImageName: "btn_n64_start",
        menuButtonImageName: "btn_n64_menu",
        analogStickBaseImageName: "btn_n64_analog_base",
        analogStickThumbImageName: "btn_n64_analog_thumb",
        backgroundPortraitImageName: "bg4",
        backgroundLandscapeImageName: "bg4"
    )

    static let theme5 = N64ControllerTheme(
        id: "theme5",
        name: "Theme 5",
        leftButtonImageName: "btn_n64_l",
        rightButtonImageName: "btn_n64_r",
        zButtonImageName: "btn_n64_z",
        zButtonImageGreenName: "btn_n64_z_blue",
        dpadImageName: "btn-dpad-5",
        buttonAImageName: "btn_n64_a",
        buttonBImageName: "btn_n64_b",
        cUpImageName: "btn_n64_c_up",
        cDownImageName: "btn_n64_c_down",
        cLeftImageName: "btn_n64_c_left",
        cRightImageName: "btn_n64_c_right",
        startButtonImageName: "btn_n64_start",
        menuButtonImageName: "btn_n64_menu",
        analogStickBaseImageName: "btn_n64_analog_base",
        analogStickThumbImageName: "btn_n64_analog_thumb",
        backgroundPortraitImageName: "bg5",
        backgroundLandscapeImageName: "bg5"
    )

    // MARK: - All Available Themes

    static let allThemes: [N64ControllerTheme] = [
        defaultTheme,
        theme2,
        theme3,
        theme4,
        theme5,
    ]
}
