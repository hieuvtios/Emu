
import Foundation

struct DSControllerTheme: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let leftButtonImageName: String
    let rightButtonImageName: String
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

    static let defaultTheme = DSControllerTheme(
        id: "default",
        name: "DS Theme 1",
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

    static let theme2 = DSControllerTheme(
        id: "theme2",
        name: "DS Theme 2",
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

    static let theme3 = DSControllerTheme(
        id: "theme3",
        name: "DS Theme 3",
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

    static let theme4 = DSControllerTheme(
        id: "theme4",
        name: "DS Theme 4",
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

    static let theme5 = DSControllerTheme(
        id: "theme5",
        name: "DS Theme 5",
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

    static let allThemes: [DSControllerTheme] = [
        defaultTheme,
        theme2,
        theme3,
        theme4,
        theme5,
    ]
}
