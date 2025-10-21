
import Foundation

struct SNESControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let leftButtonImageName: String
    let rightButtonImageName:String
    let dpadImageName: String
    let buttonAImageName: String
    let buttonBImageName: String
    let buttonXImageName: String
    let buttonYImageName: String
    let startButtonImageName: String
    let selectButtonImageName: String
    let menuButtonImageName: String
    let backgroundPortraitImageName: String
    let backgroundLandscapeImageName: String

    // MARK: - Theme Presets

    static let defaultTheme = SNESControllerTheme(
        id: "default",
        name: "Theme 1",
        leftButtonImageName: "btn_snes_l",
        rightButtonImageName: "btn_snes_r",
        dpadImageName: "btn-dpad",
        buttonAImageName: "btn_snes_a",
        buttonBImageName: "btn_snes_b",
        buttonXImageName: "btn_snes_x",
        buttonYImageName: "btn_snes_y",
        startButtonImageName: "btn_snes_start",
        selectButtonImageName: "btn_snes_select",
        menuButtonImageName: "btn_snes_menu",
        backgroundPortraitImageName: "bg1",
        backgroundLandscapeImageName: "bg1"
    )

    static let theme2 = SNESControllerTheme(
        id: "theme2",
        name: "Theme 2",
        leftButtonImageName: "btn_snes_l",
        rightButtonImageName: "btn_snes_r",
        dpadImageName: "btn-dpad-2",
        buttonAImageName: "btn_snes_a",
        buttonBImageName: "btn_snes_b",
        buttonXImageName: "btn_snes_x",
        buttonYImageName: "btn_snes_y",
        startButtonImageName: "btn_snes_start",
        selectButtonImageName: "btn_snes_select",
        menuButtonImageName: "btn_snes_menu",
        backgroundPortraitImageName: "bg2",
        backgroundLandscapeImageName: "bg2"
    )

    static let theme3 = SNESControllerTheme(
        id: "theme3",
        name: "Theme 3",
        leftButtonImageName: "btn_snes_l",
        rightButtonImageName: "btn_snes_r",
        dpadImageName: "btn-dpad-3",
        buttonAImageName: "btn_snes_a",
        buttonBImageName: "btn_snes_b",
        buttonXImageName: "btn_snes_x",
        buttonYImageName: "btn_snes_y",
        startButtonImageName: "btn_snes_start",
        selectButtonImageName: "btn_snes_select",
        menuButtonImageName: "btn_snes_menu",
        backgroundPortraitImageName: "bg3",
        backgroundLandscapeImageName: "bg3"
    )

    static let theme4 = SNESControllerTheme(
        id: "theme4",
        name: "Theme 4",
        leftButtonImageName: "btn_snes_l",
        rightButtonImageName: "btn_snes_r",
        dpadImageName: "btn-dpad-4",
        buttonAImageName: "btn_snes_a",
        buttonBImageName: "btn_snes_b",
        buttonXImageName: "btn_snes_x",
        buttonYImageName: "btn_snes_y",
        startButtonImageName: "btn_snes_start",
        selectButtonImageName: "btn_snes_select",
        menuButtonImageName: "btn_snes_menu",
        backgroundPortraitImageName: "bg4",
        backgroundLandscapeImageName: "bg4"
    )

    static let theme5 = SNESControllerTheme(
        id: "theme5",
        name: "Theme 5",
        leftButtonImageName: "btn_snes_l",
        rightButtonImageName: "btn_snes_r",
        dpadImageName: "btn-dpad-5",
        buttonAImageName: "btn_snes_a",
        buttonBImageName: "btn_snes_b",
        buttonXImageName: "btn_snes_x",
        buttonYImageName: "btn_snes_y",
        startButtonImageName: "btn_snes_start",
        selectButtonImageName: "btn_snes_select",
        menuButtonImageName: "btn_snes_menu",
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
