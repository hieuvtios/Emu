//
//  GameViewController.swift
//  GameEmulator - MVVM Refactored
//

import UIKit
import Photos
import os
import AVFoundation
import SwiftUI
import Combine
import DeltaCore
import System

// MARK: - View Model
class GameViewModel: ObservableObject {
    @Published var game: Game?
    @Published var isPaused = false
    @Published var isMenuPresented = false
    
    var emulatorCore: EmulatorCore?
    private var cancellables = Set<AnyCancellable>()
    
    func updateGame(_ newGame: Game?) {
        game = newGame
    }
    
    func pauseEmulation() {
        guard emulatorCore?.state == .running else { return }
        emulatorCore?.pause()
        isPaused = true
    }
    
    func resumeEmulation() {
        guard emulatorCore?.state == .paused else { return }
        emulatorCore?.resume()
        isPaused = false
    }
    
    func stopEmulation() {
        emulatorCore?.stop()
        game = nil
    }
}

// MARK: - Controller Manager
class ControllerManager {
    enum ControllerType {
        case snes, nes, gbc, genesis, gba, ds, standard
    }
    
    private weak var viewController: GameViewController?
    private var currentType: ControllerType?
    
    // Custom Controllers
    private var snesController: SNESDirectController?
    private var nesController: NESGameController?
    private var gbcController: GBCDirectController?
    private var genesisController: GenesisGameController?
    private var gbaController: GBADirectController?
    private var dsController: DSGameController?
    
    // Hosting Controllers
    private var snesHosting: UIHostingController<SNESControllerView>?
    private var nesHosting: UIHostingController<NESControllerView>?
    private var gbcHosting: UIHostingController<GBCControllerView>?
    private var genesisHosting: UIHostingController<GenesisControllerView>?
    private var gbaHosting: UIHostingController<GBAControllerView>?
    private var dsHosting: UIHostingController<DSControllerView>?
    
    init(viewController: GameViewController) {
        self.viewController = viewController
    }
    
    func setupController(for gameType: GameType) {
        teardownAllControllers()
        
        switch gameType {
        case .snes: setupSNESController()
        case .nes: setupNESController()
        case .gbc: setupGBCController()
        case .genesis: setupGenesisController()
        case .gba: setupGBAController()
        case .ds: setupDSController()
        default: setupStandardController()
        }
    }
    
    func teardownAllControllers() {
        teardownSNESController()
        teardownNESController()
        teardownGBCController()
        teardownGenesisController()
        teardownGBAController()
        teardownDSController()
    }
    
    // MARK: - SNES
    private func setupSNESController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = true
        let controller = SNESDirectController(name: "SNES Direct Controller", playerIndex: 0)
        snesController = controller
        
        let layout = createLayout(for: .snes)
        let view = SNESControllerView(controller: controller)
        snesHosting = setupHostingController(for: view, in: vc)
        currentType = .snes
    }
    
    private func teardownSNESController() {
        teardownHosting(&snesHosting)
        snesController?.reset()
        snesController = nil
    }
    
    // MARK: - NES
    private func setupNESController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = true
        let controller = NESGameController(name: "NES Custom Controller", systemPrefix: "nes", playerIndex: 0)
        nesController = controller
        
        if let emulatorCore = vc.emulatorCore {
            controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
        }
        
        let view = NESControllerView(controller: controller)
        nesHosting = setupHostingController(for: view, in: vc)
        currentType = .nes
    }
    
    private func teardownNESController() {
        teardownHosting(&nesHosting)
        nesController?.reset()
        nesController = nil
    }
    
    // MARK: - GBC
    private func setupGBCController() {
        guard let vc = viewController else { return }

        vc.controllerView.isHidden = true
        let controller = GBCDirectController(name: "GBC Direct Controller", playerIndex: 0)
        gbcController = controller

        let view = GBCControllerView(controller: controller)
        gbcHosting = setupHostingController(for: view, in: vc)
        currentType = .gbc
    }
    
    private func teardownGBCController() {
        teardownHosting(&gbcHosting)
        gbcController?.reset()
        gbcController = nil
    }
    
    // MARK: - Genesis
    private func setupGenesisController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = true
        let controller = GenesisGameController(name: "Genesis Custom Controller", systemPrefix: "genesis", playerIndex: 0)
        genesisController = controller
        
        if let emulatorCore = vc.emulatorCore {
            controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
        }
        
        let layout = createLayout(for: .genesis)
        let view = GenesisControllerView(controller: controller, layout: layout as! GenesisControllerLayoutDefinition)
        genesisHosting = setupHostingController(for: view, in: vc)
        currentType = .genesis
    }
    
    private func teardownGenesisController() {
        teardownHosting(&genesisHosting)
        genesisController?.reset()
        genesisController = nil
    }
    
    // MARK: - GBA
    private func setupGBAController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = true
        let controller = GBADirectController(name: "GBA Direct Controller", playerIndex: 0)
        gbaController = controller
        
        let layout = createLayout(for: .gba)
        let view = GBAControllerView(controller: controller, layout: layout as! GBAControllerLayoutDefinition)
        gbaHosting = setupHostingController(for: view, in: vc)
        currentType = .gba
    }
    
    private func teardownGBAController() {
        teardownHosting(&gbaHosting)
        gbaController?.reset()
        gbaController = nil
    }
    
    // MARK: - DS
    private func setupDSController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = true
        let controller = DSGameController(name: "Nintendo DS Controller")
        dsController = controller
        
        let layout = createLayout(for: .ds)
        let view = DSControllerView(controller: controller, layout: layout as! DSControllerLayoutDefinition)
        dsHosting = setupHostingController(for: view, in: vc)
        currentType = .ds
        
        NSLog("[ControllerManager] DS controller setup complete")
    }
    
    private func teardownDSController() {
        teardownHosting(&dsHosting)
        dsController?.reset()
        dsController = nil
    }
    
    // MARK: - Standard
    private func setupStandardController() {
        guard let vc = viewController else { return }
        
        vc.controllerView.isHidden = false
        vc.controllerView.playerIndex = 0
        
        if let emulatorCore = vc.emulatorCore {
            let inputMapping = GameViewController.DefaultInputMapping(gameController: vc.controllerView)
            vc.controllerView.addReceiver(vc, inputMapping: inputMapping)
            vc.controllerView.addReceiver(emulatorCore, inputMapping: inputMapping)
        }
        currentType = .standard
    }
    
    // MARK: - Helper Methods
    private func createLayout(for type: ControllerType) -> Any {
        guard let vc = viewController else { fatalError() }
        let screenSize = vc.view.bounds.size
        let isLandscape = screenSize.width > screenSize.height
        
        switch type {
        case .snes:
            return isLandscape ? SNESControllerLayout.landscapeLayout(screenSize: screenSize)
                               : SNESControllerLayout.portraitLayout(screenSize: screenSize)
        case .nes:
            return isLandscape ? NESControllerLayout.landscapeLayout(screenSize: screenSize)
                               : NESControllerLayout.portraitLayout(screenSize: screenSize)
        case .gbc:
            return isLandscape ? GBCControllerLayout.landscapeLayout(screenSize: screenSize)
                               : GBCControllerLayout.portraitLayout(screenSize: screenSize)
        case .genesis:
            return isLandscape ? GenesisControllerLayout.landscapeLayout(screenSize: screenSize)
                               : GenesisControllerLayout.portraitLayout(screenSize: screenSize)
        case .gba:
            return isLandscape ? GBAControllerLayout.landscapeLayout(screenSize: screenSize)
                               : GBAControllerLayout.portraitLayout(screenSize: screenSize)
        case .ds:
            return isLandscape ? DSControllerLayout.landscapeLayout(screenSize: screenSize)
                               : DSControllerLayout.portraitLayout(screenSize: screenSize)
        default:
            fatalError("No layout for standard controller")
        }
    }
    
    private func setupHostingController<Content: View>(for view: Content, in parent: UIViewController) -> UIHostingController<Content> {
        let hosting = UIHostingController(rootView: view)
        hosting.view.backgroundColor = .clear
        hosting.view.isUserInteractionEnabled = true
        hosting.view.isMultipleTouchEnabled = true
        hosting.view.isExclusiveTouch = false
        
        parent.addChild(hosting)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        parent.view.addSubview(hosting.view)
        
        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: parent.view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor)
        ])
        
        hosting.didMove(toParent: parent)
        parent.view.sendSubviewToBack(hosting.view)
        
        return hosting
    }
    
    private func teardownHosting<T>(_ hosting: inout UIHostingController<T>?) {
        hosting?.willMove(toParent: nil)
        hosting?.view.removeFromSuperview()
        hosting?.removeFromParent()
        hosting = nil
    }
    
    func resetSustainedInputs() {
        // Direct controllers don't support sustained inputs
        guard currentType == .nes || currentType == .standard else { return }
        
        if let controller = nesController {
            controller.sustainedInputs.keys.forEach { controller.unsustain($0) }
        } else if let vc = viewController {
            vc.controllerView.sustainedInputs.keys.forEach { vc.controllerView.unsustain($0) }
        }
    }
}



// MARK: - Game View Controller
class GameViewController: DeltaCore.GameViewController {
    
    // MARK: - Properties
    private lazy var viewModel = GameViewModel()
    private lazy var controllerManager = ControllerManager(viewController: self)
    private lazy var layoutManager = LayoutManager(viewController: self)
    
    private var menuButton: UIButton!
    private var gameMenuViewModel: GameMenuViewModel?
    private var gameMenuHosting: UIHostingController<GameMenuView>?
    
    private var sustainButtonsContentView: UIView!
    private var sustainButtonsBlurView: UIVisualEffectView!
    private var inputsToSustain = [AnyInput: Double]()
    
    private var isMenuButtonHeldDown = false
    private var ignoreNextMenuInput = false
    private var isSelectingSustainedButtons = false
    private var shouldResetSustainedInputs = false
    private var pausingGameController: GameController?
    private var isGyroActive = false
    private var presentedGyroAlert = false
    
    override var game: (any GameProtocol)? {
        didSet {
            handleGameChange(from: oldValue)
        }
    }
    
    // MARK: - Lifecycle
    required init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.delegate = self
        setupNotifications()
    }
    
    private func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateControllers), name: .externalGameControllerDidConnect, object: nil)
        nc.addObserver(self, selector: #selector(updateControllers), name: .externalGameControllerDidDisconnect, object: nil)
        nc.addObserver(self, selector: #selector(emulationDidQuit), name: EmulatorCore.emulationDidQuitNotification, object: nil)
        nc.addObserver(self, selector: #selector(sceneWillConnect), name: UIScene.willConnectNotification, object: nil)
        nc.addObserver(self, selector: #selector(sceneDidDisconnect), name: UIScene.didDisconnectNotification, object: nil)

        #if DEBUG
        // Observe theme changes to update menu button
        if #available(iOS 15.0, *) {
            nc.addObserver(self, selector: #selector(gbcThemeDidChange), name: NSNotification.Name("GBCThemeDidChangeNotification"), object: nil)
            nc.addObserver(self, selector: #selector(snesThemeDidChange), name: NSNotification.Name("SNESThemeDidChangeNotification"), object: nil)
        }
        #endif
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        setupSustainButtonsView()
//        setupMenuButton()
        setupMenuButtonSNES()
        updateControllers()
    }
    
    override func viewDidLayoutSubviews() {
        layoutManager.layoutGameViewAndController()
        
        if let menuButton = menuButton {
            view.bringSubviewToFront(menuButton)
        }
        
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        handleRotation(coordinator: coordinator)
    }
    
    // MARK: - Game Management
    private func handleGameChange(from oldGame: (any GameProtocol)?) {
        let game = self.game as? Game
        viewModel.updateGame(game)

        emulatorCore?.saveHandler = { _ in }

        if oldGame?.fileURL != game?.fileURL {
            shouldResetSustainedInputs = true
        }

        updateControllers()
        updateAudio()
        updateMenuButtonImage()
        presentedGyroAlert = false
    }
    
    @objc private func updateControllers() {
        guard isViewLoaded else { return }
        
        if let game = game as? Game {
            controllerManager.setupController(for: game.type)
        } else {
            controllerManager.teardownAllControllers()
            controllerView.isHidden = true
            controllerView.playerIndex = nil
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        if shouldResetSustainedInputs {
            controllerManager.resetSustainedInputs()
            shouldResetSustainedInputs = false
        }
        
        updateControllerSkin()
        
        if let menuButton = menuButton {
            view.bringSubviewToFront(menuButton)
        }
    }
    
    // MARK: - Rotation Handling
    private func handleRotation(coordinator: UIViewControllerTransitionCoordinator) {
        guard UIApplication.shared.applicationState != .background else { return }
        
        emulatorCore?.videoManager.isEnabled = false
        let isFirstResponder = controllerView.isFirstResponder
        controllerView.resignFirstResponder()
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateControllerSkin()
            self.controllerManager.setupController(for: (self.game as? Game)?.type ?? .unknown)
            self.updateGameViews()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if isFirstResponder {
                self.controllerView.becomeFirstResponder()
            }
            
            self.emulatorCore?.videoManager.isEnabled = true
            
            for gameView in self.gameViews {
                gameView.setNeedsLayout()
                gameView.layoutIfNeeded()
            }
            
            self.emulatorCore?.videoManager.render()
        })
    }
    
    // MARK: - Setup Methods
    private func setupSustainButtonsView() {
        sustainButtonsContentView = UIView()
        sustainButtonsContentView.translatesAutoresizingMaskIntoConstraints = false
        sustainButtonsContentView.isHidden = true
        view.insertSubview(sustainButtonsContentView, aboveSubview: gameView)
        
        let blurEffect = UIBlurEffect(style: .dark)
        sustainButtonsBlurView = UIVisualEffectView(effect: blurEffect)
        sustainButtonsBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sustainButtonsContentView.addSubview(sustainButtonsBlurView)
        
        NSLayoutConstraint.activate([
            sustainButtonsContentView.leadingAnchor.constraint(equalTo: gameView.leadingAnchor),
            sustainButtonsContentView.trailingAnchor.constraint(equalTo: gameView.trailingAnchor),
            sustainButtonsContentView.topAnchor.constraint(equalTo: gameView.topAnchor),
            sustainButtonsContentView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    private func setupGreenImage(){
        // Create the greenButton
        let greenButton = UIButton(type: .custom)
        // Set its image with alwaysOriginal rendering
        let greenImage = UIImage(named: "btn-green")?.withRenderingMode(.alwaysOriginal)
        greenButton.setImage(greenImage, for: .normal)
        // Configure appearance
        greenButton.backgroundColor = .clear
        greenButton.translatesAutoresizingMaskIntoConstraints = false
        // Add to view hierarchy
        view.addSubview(greenButton)
        // Layout constraints
        NSLayoutConstraint.activate([
            greenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            greenButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    private func setupMenuButton() {
        menuButton = UIButton(type: .custom)

        // Set initial button image
        updateMenuButtonImage()

        // Button appearance
        menuButton.backgroundColor = .clear
        menuButton.translatesAutoresizingMaskIntoConstraints = false

        // Touch handler
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        // Add to view
        view.addSubview(menuButton)
        view.bringSubviewToFront(menuButton)

        // Layout constraints
        NSLayoutConstraint.activate([
//            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),

            menuButton.widthAnchor.constraint(equalToConstant: 60),
            menuButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupMenuButtonSNES() {
        menuButton = UIButton(type: .custom)

        // Set initial button image
        updateMenuButtonImage()

        // Button appearance
        menuButton.backgroundColor = .clear
        menuButton.translatesAutoresizingMaskIntoConstraints = false

        // Touch handler
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        // Add to view
        view.addSubview(menuButton)
        view.bringSubviewToFront(menuButton)

        // Layout constraints
        NSLayoutConstraint.activate([
//            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),

//            menuButton.widthAnchor.constraint(equalToConstant: 60),
//            menuButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func updateMenuButtonImage() {
        guard let menuButton = menuButton else { return }
        var imageName = "btn_snes_menu" // Default fallback

        if let game = game as? Game {
            print(game.type)
            switch game.type {
            case .nes:
                if let themeData = UserDefaults.standard.data(forKey: "NESControllerTheme"),
                   let theme = try? JSONDecoder().decode(NESControllerTheme.self, from: themeData) {
                    imageName = theme.menuButtonImageName
                    print("image name \(imageName)")

                }
                
            case .gbc:
                if let themeData = UserDefaults.standard.data(forKey: "GBCControllerTheme"),
                   let theme = try? JSONDecoder().decode(GBCControllerTheme.self, from: themeData) {
                    imageName = theme.menuButtonImageName
                }
                setupGreenImage()

            case .gba:
                if let themeData = UserDefaults.standard.data(forKey: "GBCControllerTheme"),
                   let theme = try? JSONDecoder().decode(GBCControllerTheme.self, from: themeData) {
                    imageName = theme.menuButtonImageName
                }
                setupGreenImage()

            case .snes:
                if let themeData = UserDefaults.standard.data(forKey: "SNESControllerTheme"),
                   let theme = try? JSONDecoder().decode(SNESControllerTheme.self, from: themeData) {
                    imageName = theme.menuButtonImageName
            }
            case .genesis:
                if let themeData = UserDefaults.standard.data(forKey: "GenesisControllerTheme"),
                   let theme = try? JSONDecoder().decode(GenesisControllerTheme.self, from: themeData) {
                    imageName = theme.menuButtonImageName
                }
            default:
                break
            }
        }

        let menuImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        menuButton.setImage(menuImage, for: .normal)
    }
    
    // MARK: - Menu Actions
    @objc private func menuButtonTapped() {
        presentGameMenu()
    }
    
    private func presentGameMenu() {
        viewModel.pauseEmulation()
        
        let viewModel = GameMenuViewModel()
        viewModel.configure(emulatorCore: emulatorCore, gameView: gameView, game: game as? Game)
        gameMenuViewModel = viewModel
        
        let menuView = GameMenuView(viewModel: viewModel)
        let hosting = UIHostingController(rootView: menuView)
        hosting.modalPresentationStyle = .pageSheet
        
        if let sheet = hosting.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(hosting, animated: true)
        gameMenuHosting = hosting
        hosting.presentationController?.delegate = self
    }
    
    // MARK: - Audio Configuration
    private func updateAudio() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        
        emulatorCore?.audioManager.respectsSilentMode = false
    }
    
    // MARK: - Helper Methods
    private func updateControllerSkin() {
        guard isViewLoaded, let game = game else { return }
        
        if let controllerSkin = DeltaCore.ControllerSkin.standardControllerSkin(for: game.type) {
            controllerView.controllerSkin = controllerSkin
        }
    }
    
    private func updateGameViews() {
        // Simplified game views update logic
        for gameView in gameViews {
            gameView.isEnabled = true
            gameView.isHidden = false
            gameView.isAirPlaying = false
        }
    }
    
    @objc private func emulationDidQuit(with notification: Notification) {
        guard let core = notification.object as? EmulatorCore, core == emulatorCore else { return }
        
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }
            self.quitEmulation()
        }
    }
    
    private func quitEmulation() {
        viewModel.stopEmulation()
        performSegue(withIdentifier: "showGamesViewController", sender: nil)
    }
    
    @objc private func sceneWillConnect(with notification: Notification) {}
    @objc private func sceneDidDisconnect(with notification: Notification) {}

    #if DEBUG
    @objc private func gbcThemeDidChange(with notification: Notification) {
        // Update menu button image when theme changes
        updateMenuButtonImage()
    }

    @objc private func snesThemeDidChange(with notification: Notification) {
        // Update menu button image when SNES theme changes
        updateMenuButtonImage()
    }
    #endif
}

// MARK: - Delegates
extension GameViewController: GameViewControllerDelegate {}

extension GameViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.resumeEmulation()
        gameMenuViewModel?.cleanup()
        gameMenuViewModel = nil
        gameMenuHosting = nil
    }
}

// MARK: - Supporting Types
private extension GameViewController {
    struct PausedSaveState: SaveStateProtocol {
        var fileURL: URL
        var gameType: GameType
        var isSaved = false
    }
    
    struct DefaultInputMapping: GameControllerInputMappingProtocol {
        let gameController: GameController
        
        var gameControllerInputType: GameControllerInputType {
            gameController.inputType
        }
        
        func input(forControllerInput controllerInput: Input) -> Input? {
            if let mappedInput = gameController.defaultInputMapping?.input(forControllerInput: controllerInput) {
                return mappedInput
            }
            
            guard controllerInput.type == .controller(.controllerSkin) else { return nil }
            return ActionInput(stringValue: controllerInput.stringValue)
        }
    }
    
    struct SustainInputsMapping: GameControllerInputMappingProtocol {
        let gameController: GameController
        
        var gameControllerInputType: GameControllerInputType {
            gameController.inputType
        }
        
        func input(forControllerInput controllerInput: Input) -> Input? {
            if let mappedInput = gameController.defaultInputMapping?.input(forControllerInput: controllerInput),
               mappedInput == StandardGameControllerInput.menu {
                return mappedInput
            }
            return controllerInput
        }
    }
}
