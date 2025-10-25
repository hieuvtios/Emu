////
////  GenesisDirectController.swift
////  GameEmulator
////
////  Direct Genesis controller using Genesis Plus GX bridge (no DeltaCore)
////
//
//import UIKit
//
//class GenesisDirectController {
//
//    // MARK: - Properties
//
//    let name: String
//    let playerIndex: Int
//    private let inputBridge: GenesisInputBridge
//
//    // MARK: - Initialization
//
//    init(name: String, playerIndex: Int = 0) {
//        self.name = name
//        self.playerIndex = playerIndex
//        self.inputBridge = GenesisInputBridge.shared()
//    }
//
//    deinit {
//        self.reset()
//    }
//
//    // MARK: - Public Methods
//
//    func pressButton(_ button: GenesisButtonType) {
//        inputBridge.pressButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
//    }
//
//    func releaseButton(_ button: GenesisButtonType) {
//        inputBridge.releaseButton(Int32(button.buttonMask), forPlayer: Int32(playerIndex))
//    }
//
//    func pressDPadButtons(_ buttons: [GenesisButtonType]) {
//        for button in buttons {
//            pressButton(button)
//        }
//    }
//
//    func releaseAllDPadButtons() {
//        for button in GenesisButtonType.dpadButtons {
//            releaseButton(button)
//        }
//    }
//
//    func reset() {
//        inputBridge.resetAllInputs()
//    }
//}
