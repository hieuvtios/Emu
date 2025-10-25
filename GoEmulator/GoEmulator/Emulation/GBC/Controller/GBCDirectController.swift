////
////  GBCDirectController.swift
////  GameEmulator
////
////  Direct GBC controller using Gambatte bridge (no DeltaCore)
////
//
//import UIKit
//
//class GBCDirectController {
//
//    // MARK: - Properties
//
//    let name: String
//    let playerIndex: Int
//    private let inputBridge: GBCInputBridge
//
//    // MARK: - Initialization
//
//    init(name: String, playerIndex: Int = 0) {
//        self.name = name
//        self.playerIndex = playerIndex
//        self.inputBridge = GBCInputBridge.shared()
//    }
//
//    deinit {
//        self.reset()
//    }
//
//    // MARK: - Public Methods
//
//    func pressButton(_ button: GBCButtonType) {
//        inputBridge.pressButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
//    }
//
//    func releaseButton(_ button: GBCButtonType) {
//        inputBridge.releaseButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
//    }
//
//    func pressDPadButtons(_ buttons: [GBCButtonType]) {
//        for button in buttons {
//            pressButton(button)
//        }
//    }
//
//    func releaseAllDPadButtons() {
//        for button in GBCButtonType.dpadButtons {
//            releaseButton(button)
//        }
//    }
//
//    func reset() {
//        inputBridge.resetAllInputs()
//    }
//}
