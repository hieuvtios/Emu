//
//  GameViewController.swift
//  GameEmulator
//
//  Created by Đỗ Việt on 25/9/25.
//

import UIKit
import Photos
import os
import AVFoundation
import SwiftUI
import Combine

import DeltaCore
import System

class GameScene: UIWindowScene
{
    fileprivate(set) var game: Game? {
        didSet {
            self.title = self.game?.name
        }
    }
}

private var kvoContext = 0

private extension DeltaCore.ControllerSkin
{
    func hasTouchScreen(for traits: DeltaCore.ControllerSkin.Traits) -> Bool
    {
        let hasTouchScreen = self.items(for: traits)?.contains(where: { $0.kind == .touchScreen }) ?? false
        return hasTouchScreen
    }
}

private extension GameViewController
{
    struct PausedSaveState: SaveStateProtocol
    {
        var fileURL: URL
        var gameType: GameType
        
        var isSaved = false
        
        init(fileURL: URL, gameType: GameType)
        {
            self.fileURL = fileURL
            self.gameType = gameType
        }
    }
    
    struct DefaultInputMapping: GameControllerInputMappingProtocol
    {
        let gameController: GameController
        
        var gameControllerInputType: GameControllerInputType {
            return self.gameController.inputType
        }
        
        func input(forControllerInput controllerInput: Input) -> Input?
        {
            if let mappedInput = self.gameController.defaultInputMapping?.input(forControllerInput: controllerInput)
            {
                return mappedInput
            }
            
            // Only intercept controller skin inputs.
            guard controllerInput.type == .controller(.controllerSkin) else { return nil }
            
            let actionInput = ActionInput(stringValue: controllerInput.stringValue)
            return actionInput
        }
    }
    
    struct SustainInputsMapping: GameControllerInputMappingProtocol
    {
        let gameController: GameController
        
        var gameControllerInputType: GameControllerInputType {
            return self.gameController.inputType
        }
        
        func input(forControllerInput controllerInput: Input) -> Input?
        {
            if let mappedInput = self.gameController.defaultInputMapping?.input(forControllerInput: controllerInput), mappedInput == StandardGameControllerInput.menu
            {
                return mappedInput
            }
            
            return controllerInput
        }
    }
}

class GameViewController: DeltaCore.GameViewController {
    
    override var game: (any GameProtocol)? {
        willSet {
//            self.emulatorCore?.removeObserver(self, forKeyPath: #keyPath(EmulatorCore.state), context: &kvoContext)
        }
        
        didSet {
//            self.emulatorCore?.addObserver(self, forKeyPath: #keyPath(EmulatorCore.state), options: [.old], context: &kvoContext)
            
            let game = self.game as? Game
            self.emulatorCore?.saveHandler = { _ in  }
            
            if oldValue?.fileURL != game?.fileURL
            {
                self.shouldResetSustainedInputs = true
            }
            
            self.updateControllers()
            self.updateAudio()
            
            self.presentedGyroAlert = false
        }
    }
    
    private var isGameScene: Bool {
        let gameScene = self.view.window?.windowScene as? GameScene
        return gameScene != nil
    }
    
    //MARK: - Private Properties -
    //private var pauseViewController: PauseViewController?
    private var pausingGameController: GameController?
    
    // Prevents the same save state from being saved multiple times
    private var pausedSaveState: PausedSaveState? {
        didSet
        {
            if let saveState = oldValue, self.pausedSaveState == nil
            {
                do
                {
                    try FileManager.default.removeItem(at: saveState.fileURL)
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    private var _isLoadingSaveState = false
    
    // Online Multiplayer
    private var onlineConnectionDate: Date?
    private var onlineBackgroundTaskID: UIBackgroundTaskIdentifier?
    
    // Handoff
    private var isContinuingHandoff = false
    
    // Gestures
    private var isMenuButtonHeldDown = false
    private var ignoreNextMenuInput = false
        
    // Sustain Buttons
    private var isSelectingSustainedButtons = false
    private var sustainInputsMapping: SustainInputsMapping?
    private var shouldResetSustainedInputs = false
    
    private var sustainButtonsContentView: UIView!
    private var sustainButtonsBlurView: UIVisualEffectView!
    private var inputsToSustain = [AnyInput: Double]()
    
    private var isGyroActive = false
    private var presentedGyroAlert = false
    
    private var presentedJITAlert = false
    
    private var isPreparingAchievements = false

    // Custom SNES Controller
    private var customSNESController: SNESGameController?
    private var customSNESControllerHosting: UIHostingController<SNESControllerView>?

    // Custom NES Controller
    private var customNESController: NESGameController?
    private var customNESControllerHosting: UIHostingController<NESControllerView>?

    // Game Menu
    private var menuButton: UIButton!
    private var gameMenuViewModel: GameMenuViewModel?
    private var gameMenuHosting: UIHostingController<GameMenuView>?

    override var shouldAutorotate: Bool {
        return !self.isGyroActive
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard self.isGyroActive else { return super.supportedInterfaceOrientations }
        
        // Lock orientation to whatever current device orientation is.
        
        switch UIDevice.current.orientation
        {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
            
        // UIDevice.landscapeLeft == UIInterfaceOrientation.landscapeRight (and vice versa)
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
            
        default: return super.supportedInterfaceOrientations
        }
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init()
    {
        super.init()
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    private func initialize()
    {
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.updateControllers), name: .externalGameControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.updateControllers), name: .externalGameControllerDidDisconnect, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.emulationDidQuit(with:)), name: EmulatorCore.emulationDidQuitNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.sceneWillConnect(with:)), name: UIScene.willConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.sceneDidDisconnect(with:)), name: UIScene.didDisconnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.sceneSessionWillQuit(with:)), name: UISceneSession.willQuitNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.sceneKeyboardFocusDidChange(with:)), name: UIScene.keyboardFocusDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.keyboardDidShow(with:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.keyboardDidChangeFrame(with:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    deinit
    {
        self.emulatorCore?.removeObserver(self, forKeyPath: #keyPath(EmulatorCore.state), context: &kvoContext)
    }
    
    // MARK: - GameControllerReceiver -
    override func gameController(_ gameController: GameController, didActivate input: Input, value: Double)
    {
        super.gameController(gameController, didActivate: input, value: value)
        
        // Ignore unless we're the active scene.
        guard self.view.window?.windowScene?.hasKeyboardFocus == true else { return }

        if self.isSelectingSustainedButtons
        {
            guard let pausingGameController = self.pausingGameController, gameController == pausingGameController else { return }

            if input != StandardGameControllerInput.menu
            {
                self.inputsToSustain[AnyInput(input)] = value
            }
        }
        else if let standardInput = StandardGameControllerInput(input: input), standardInput == .menu, gameController.inputType == .controllerSkin
        {
            self.isMenuButtonHeldDown = true

            let sustainInputsMapping = SustainInputsMapping(gameController: gameController)
            gameController.addReceiver(self, inputMapping: sustainInputsMapping)
        }
        else if self.isMenuButtonHeldDown
        {
            self.ignoreNextMenuInput = true

            if gameController.sustainedInputs.keys.contains(AnyInput(input))
            {
                DispatchQueue.main.async {
                    gameController.unsustain(input)
                }
            }
            else
            {
                gameController.sustain(input, value: value)
            }
        }
    }
    
    override func gameController(_ gameController: GameController, didDeactivate input: Input)
    {
        super.gameController(gameController, didDeactivate: input)

        // Ignore unless we're the active scene.
        guard self.view.window?.windowScene?.hasKeyboardFocus == true else { return }

        if self.isSelectingSustainedButtons
        {
            if input.isContinuous
            {
                self.inputsToSustain[AnyInput(input)] = nil
            }
        }
        else if let standardInput = StandardGameControllerInput(input: input), standardInput == .menu, gameController.inputType == .controllerSkin
        {
            self.isMenuButtonHeldDown = false

            // Reset controller mapping back to what it should be.
            self.updateControllers()
        }
    }
}

//MARK: - UIViewController -
/// UIViewController
extension GameViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Lays out self.gameView, so we can pin self.sustainButtonsContentView to it without resulting in a temporary "cannot satisfy constraints".
        self.view.layoutIfNeeded()
        
        //self.controllerView.translucentControllerSkinOpacity = Settings.translucentControllerSkinOpacity
        
        // Sustain Button
        self.sustainButtonsContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.gameView.bounds.width, height: self.gameView.bounds.height - 600))
        self.sustainButtonsContentView.translatesAutoresizingMaskIntoConstraints = false
        self.sustainButtonsContentView.isHidden = true
        self.view.insertSubview(self.sustainButtonsContentView, aboveSubview: self.gameView)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        self.sustainButtonsBlurView = UIVisualEffectView(effect: blurEffect)
        self.sustainButtonsBlurView.frame = CGRect(x: 0, y: 0, width: self.sustainButtonsContentView.bounds.width, height: self.sustainButtonsContentView.bounds.height)
        self.sustainButtonsBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sustainButtonsContentView.addSubview(self.sustainButtonsBlurView)

        // Auto Layout
        NSLayoutConstraint.activate([
            self.sustainButtonsContentView.leadingAnchor.constraint(equalTo: self.gameView.leadingAnchor),
            self.sustainButtonsContentView.trailingAnchor.constraint(equalTo: self.gameView.trailingAnchor),
            self.sustainButtonsContentView.topAnchor.constraint(equalTo: self.gameView.topAnchor),
            self.sustainButtonsContentView.heightAnchor.constraint(equalToConstant: 200) // or whatever height
        ])

        // Setup Menu Button
        setupMenuButton()

        self.updateControllers()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
//        if self.emulatorCore?.deltaCore == MelonDS.core, ProcessInfo.processInfo.isJITAvailable
//        {
//            self.showJITEnabledAlert()
//        }
        
        self.startGameActivity()
        
        if let scene = UIApplication.shared.externalDisplayScene
        {
            // We have priority, so replace whatever is currently on external display.
            self.connectExternalDisplay(for: scene)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        guard UIApplication.shared.applicationState != .background else { return }

        // Temporarily disable video rendering during transition to prevent rendering artifacts
        // Keep emulation running to maintain audio continuity and game state
        self.emulatorCore?.videoManager.isEnabled = false

        // Note: We do NOT pause emulation - only disable video rendering
        // This keeps audio playing and game logic running smoothly

        // Track first responder status to restore later
        let isControllerViewFirstResponder = self.controllerView.isFirstResponder
        self.controllerView.resignFirstResponder()

        coordinator.animate(alongsideTransition: { (context) in
            // Update controller skin for new orientation
            self.updateControllerSkin()

            // Update custom SNES controller layout if active
            if self.customSNESController != nil {
                self.setupCustomSNESController()
            }

            // Update custom NES controller layout if active
            if self.customNESController != nil {
                self.setupCustomNESController()
            }

            // Update game views for new orientation
            self.updateGameViews()

            // Force layout update to ensure proper bounds/extent synchronization
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()

        }, completion: { (context) in
            // Restore first responder status
            if isControllerViewFirstResponder {
                self.controllerView.becomeFirstResponder()
            }

            // CRITICAL: Always re-enable video rendering after rotation
            // This fixes the white screen issue where video stays disabled
            self.emulatorCore?.videoManager.isEnabled = true

            // Force game views to update their layout for new bounds
            for gameView in self.gameViews {
                gameView.setNeedsLayout()
                gameView.layoutIfNeeded()
            }

            // Force a render to refresh the display with new layout
            // This is essential after rotation to update the video output with new bounds
            self.emulatorCore?.videoManager.render()
        })
    }
    
    override func viewDidLayoutSubviews()
    {
        // DON'T call super.viewDidLayoutSubviews() - we're completely overriding the base class layout
        // super.viewDidLayoutSubviews() centers the game view, but we want top alignment

        // Instead, manually handle the layout with top alignment
        customLayoutGameViewAndController()

//        if let sustainButtonsBackgroundView
//        {
//            // Fixes Hold Button description laying out vertically after orientation change.
//            sustainButtonsBackgroundView.detailTextLabel.preferredMaxLayoutWidth = sustainButtonsBackgroundView.bounds.width
//        }

        // Ensure menu button stays on top after layout
        if let menuButton = menuButton {
            self.view.bringSubviewToFront(menuButton)
        }

        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }

    private func customLayoutGameViewAndController()
    {
        // Get safe area and screen dimensions
        let safeAreaInsets = self.view.safeAreaInsets
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height

        // Calculate controller view frame and height
        let controllerViewFrame: CGRect
        let controllerViewHeight: CGFloat

        if !self.controllerView.isHidden, customSNESController == nil, customNESController == nil
        {
            let intrinsicContentSize = self.controllerView.intrinsicContentSize
            if intrinsicContentSize.height != UIView.noIntrinsicMetric && intrinsicContentSize.width != UIView.noIntrinsicMetric
            {
                controllerViewHeight = (screenWidth / intrinsicContentSize.width) * intrinsicContentSize.height
                controllerViewFrame = CGRect(x: 0, y: screenHeight - controllerViewHeight,
                                            width: screenWidth, height: controllerViewHeight)
            }
            else
            {
                controllerViewHeight = 0
                controllerViewFrame = .zero
            }

            self.controllerView.frame = controllerViewFrame
        }
        else
        {
            controllerViewHeight = 0
            controllerViewFrame = .zero
        }

        // Calculate available space for game view (between top safe area and controller)
        let availableWidth = screenWidth - safeAreaInsets.left - safeAreaInsets.right
        let availableHeight = screenHeight - controllerViewHeight - safeAreaInsets.top - safeAreaInsets.bottom

        // Get game aspect ratio from emulator core
        let gameScreenDimensions = self.emulatorCore?.preferredRenderingSize ?? CGSize(width: 256, height: 224)
        let aspectRatio = gameScreenDimensions.width / gameScreenDimensions.height

        // Calculate game view dimensions maintaining aspect ratio
        var gameViewWidth = availableWidth
        var gameViewHeight = gameViewWidth / aspectRatio

        // If calculated height exceeds available height, fit to height instead
        if gameViewHeight > availableHeight
        {
            gameViewHeight = availableHeight
            gameViewWidth = gameViewHeight * aspectRatio
        }

        // Position game view at TOP (not centered) with horizontal centering
        let gameViewX = safeAreaInsets.left + (availableWidth - gameViewWidth) / 2
        let gameViewY = safeAreaInsets.top

        let gameViewFrame = CGRect(x: gameViewX, y: gameViewY, width: gameViewWidth, height: gameViewHeight)

        // Apply the frame to the game view
        if let gameView = self.gameViews.first
        {
            gameView.frame = gameViewFrame
        }

        // Handle emulator core rendering refresh if needed
        if let emulatorCore = self.emulatorCore, emulatorCore.state != .running
        {
            emulatorCore.videoManager.render()
        }
    }
}

//MARK: - Game Menu -
private extension GameViewController
{
    func setupMenuButton() {
        // Create menu button
        menuButton = UIButton(type: .system)
        menuButton.setTitle("Menu", for: .normal)
        menuButton.setTitleColor(.white, for: .normal)
        menuButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        menuButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        menuButton.layer.cornerRadius = 8
        menuButton.layer.borderWidth = 1.5
        menuButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        // Add shadow for better visibility
        menuButton.layer.shadowColor = UIColor.black.cgColor
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        menuButton.layer.shadowRadius = 3
        menuButton.layer.shadowOpacity = 0.3

        // IMPORTANT: Add to view above all other subviews to ensure it's tappable
        self.view.addSubview(menuButton)
        self.view.bringSubviewToFront(menuButton)

        // Position beside Start button (center-bottom area)
        // Using safe area bottom with offset to position near controller center buttons
        NSLayoutConstraint.activate([
            menuButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 60),
            menuButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            menuButton.widthAnchor.constraint(equalToConstant: 70),
            menuButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc func menuButtonTapped() {
        presentGameMenu()
    }

    func presentGameMenu() {
        // Pause emulation
        if self.emulatorCore?.state == .running {
            self.emulatorCore?.pause()
        }

        // Create view model
        let viewModel = GameMenuViewModel()
        viewModel.configure(emulatorCore: self.emulatorCore, gameView: self.gameView, game: self.game as? Game)
        self.gameMenuViewModel = viewModel

        // Create SwiftUI view
        let menuView = GameMenuView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: menuView)
        hostingController.modalPresentationStyle = .pageSheet

        // Configure sheet
        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        // Present menu
        self.present(hostingController, animated: true)
        self.gameMenuHosting = hostingController

        // Resume when dismissed
        hostingController.presentationController?.delegate = self
    }

    func dismissGameMenu() {
        gameMenuHosting?.dismiss(animated: true) { [weak self] in
            // Resume emulation
            if self?.emulatorCore?.state == .paused {
                self?.emulatorCore?.resume()
            }

            // Cleanup
            self?.gameMenuViewModel?.cleanup()
            self?.gameMenuViewModel = nil
            self?.gameMenuHosting = nil
        }
    }
}

//MARK: - UIAdaptivePresentationControllerDelegate -
extension GameViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Resume emulation when menu is dismissed by swipe
        if self.emulatorCore?.state == .paused {
            self.emulatorCore?.resume()
        }

        // Cleanup
        gameMenuViewModel?.cleanup()
        gameMenuViewModel = nil
        gameMenuHosting = nil
    }
}

//MARK: - Controllers -
private extension GameViewController
{
    @objc func updateControllers()
    {
        // Only proceed if view is loaded
        guard self.isViewLoaded else { return }

        if let game = self.game {
            // Check game type and setup appropriate custom controller
            if game.type == .snes {
                teardownCustomNESController()
                setupCustomSNESController()
            } else if game.type == .nes {
                teardownCustomSNESController()
                setupCustomNESController()
            } else {
                // Use standard DeltaCore controller for other systems
                teardownCustomSNESController()
                teardownCustomNESController()
                setupStandardController()
            }
        } else {
            // No game loaded
            teardownCustomSNESController()
            teardownCustomNESController()
            self.controllerView.isHidden = true
            self.controllerView.playerIndex = nil
        }

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        if self.shouldResetSustainedInputs {
            resetSustainedInputs()
            self.shouldResetSustainedInputs = false
        }

        self.updateControllerSkin()

        // Ensure menu button stays on top after controller updates
        if let menuButton = menuButton {
            self.view.bringSubviewToFront(menuButton)
        }
    }

    func setupCustomSNESController() {
        // Clean up existing if any
        teardownCustomSNESController()

        // Hide standard controller view
        self.controllerView.isHidden = true

        // Create custom controller using generic base class
        let controller = SNESGameController(name: "SNES Custom Controller", systemPrefix: "snes", playerIndex: 0)
        self.customSNESController = controller

        // Add as receiver to emulator core
        if let emulatorCore = self.emulatorCore {
            controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
        }

        // Determine layout based on orientation
        let screenSize = self.view.bounds.size
        let layout: SNESControllerLayoutDefinition

        if screenSize.width > screenSize.height {
            layout = SNESControllerLayout.landscapeLayout(screenSize: screenSize)
        } else {
            layout = SNESControllerLayout.portraitLayout(screenSize: screenSize)
        }

        // Create SwiftUI view
        let controllerView = SNESControllerView(controller: controller, layout: layout)
        let hostingController = UIHostingController(rootView: controllerView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.isUserInteractionEnabled = true
        hostingController.view.isMultipleTouchEnabled = true
        hostingController.view.isExclusiveTouch = false

        // Add to view hierarchy
        self.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
        self.customSNESControllerHosting = hostingController

        // Ensure controller is on top of game view
        self.view.bringSubviewToFront(hostingController.view)

        // Ensure menu button stays on top of everything
        if let menuButton = menuButton {
            self.view.bringSubviewToFront(menuButton)
        }
    }

    func teardownCustomSNESController() {
        if let hosting = customSNESControllerHosting {
            hosting.willMove(toParent: nil)
            hosting.view.removeFromSuperview()
            hosting.removeFromParent()
            self.customSNESControllerHosting = nil
        }

        if let controller = customSNESController {
            controller.reset()
            self.customSNESController = nil
        }
    }

    func setupCustomNESController() {
        // Clean up existing if any
        teardownCustomNESController()

        // Hide standard controller view
        self.controllerView.isHidden = true

        // Create custom controller using generic base class
        let controller = NESGameController(name: "NES Custom Controller", systemPrefix: "nes", playerIndex: 0)
        self.customNESController = controller

        // Add as receiver to emulator core
        if let emulatorCore = self.emulatorCore {
            controller.addReceiver(emulatorCore, inputMapping: controller.defaultInputMapping)
        }

        // Determine layout based on orientation
        let screenSize = self.view.bounds.size
        let layout: NESControllerLayoutDefinition

        if screenSize.width > screenSize.height {
            layout = NESControllerLayout.landscapeLayout(screenSize: screenSize)
        } else {
            layout = NESControllerLayout.portraitLayout(screenSize: screenSize)
        }

        // Create SwiftUI view
        let controllerView = NESControllerView(controller: controller, layout: layout)
        let hostingController = UIHostingController(rootView: controllerView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.isUserInteractionEnabled = true
        hostingController.view.isMultipleTouchEnabled = true
        hostingController.view.isExclusiveTouch = false

        // Add to view hierarchy
        self.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
        self.customNESControllerHosting = hostingController

        // Ensure controller is on top of game view
        self.view.bringSubviewToFront(hostingController.view)

        // Ensure menu button stays on top of everything
        if let menuButton = menuButton {
            self.view.bringSubviewToFront(menuButton)
        }
    }

    func teardownCustomNESController() {
        if let hosting = customNESControllerHosting {
            hosting.willMove(toParent: nil)
            hosting.view.removeFromSuperview()
            hosting.removeFromParent()
            self.customNESControllerHosting = nil
        }

        if let controller = customNESController {
            controller.reset()
            self.customNESController = nil
        }
    }

    func setupStandardController() {
        self.controllerView.isHidden = false
        self.controllerView.playerIndex = 0

        var controllers = [GameController]()
        controllers.append(self.controllerView)

        if let emulatorCore = self.emulatorCore, let game = self.game {
            for gameController in controllers {
                if gameController.playerIndex != nil {
                    let inputMapping = DefaultInputMapping(gameController: gameController)
                    gameController.addReceiver(self, inputMapping: inputMapping)
                    gameController.addReceiver(emulatorCore, inputMapping: inputMapping)
                } else {
                    gameController.removeReceiver(self)
                    gameController.removeReceiver(emulatorCore)
                }
            }
        }
    }

    func resetSustainedInputs() {
        let controllers: [GameController]

        if let customController = customSNESController {
            controllers = [customController]
        } else if let customController = customNESController {
            controllers = [customController]
        } else {
            controllers = [self.controllerView]
        }

        for controller in controllers {
            for input in controller.sustainedInputs.keys {
                controller.unsustain(input)
            }
        }
    }

    func updateControllerSkin()
    {
        guard self.isViewLoaded, let game = self.game else { return }

        // Skip if using custom controllers
        if customSNESController != nil || customNESController != nil {
            return
        }

        // Load the standard controller skin for other systems
        if let controllerSkin = DeltaCore.ControllerSkin.standardControllerSkin(for: game.type)
        {
            self.controllerView.controllerSkin = controllerSkin
        }
    }

    @objc func emulationDidQuit(with notification: Notification)
    {
        guard let emulatorCore = notification.object as? EmulatorCore, emulatorCore == self.emulatorCore else { return }
        
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }
            
            // Wait for emulation to stop completely before performing segue.
            var token: NSKeyValueObservation?
            token = self.emulatorCore?.observe(\.state, options: [.initial]) { (emulatorCore, change) in
                guard emulatorCore.state == .stopped else { return }
                
                DispatchQueue.main.async {
                    self.quitEmulation()
                }
                
                token?.invalidate()
            }
        }
    }
    
    @objc func sceneWillConnect(with notification: Notification)
    {
        guard let scene = notification.object as? ExternalDisplayScene else { return }
        self.connectExternalDisplay(for: scene)
    }
    
    @objc func sceneDidDisconnect(with notification: Notification)
    {
        // Always allow disconnecting external displays.
        // guard Settings.supportsExternalDisplays else { return }
        
        guard let scene = notification.object as? ExternalDisplayScene else { return }
        self.disconnectExternalDisplay(for: scene)
    }
    
    @objc func sceneSessionWillQuit(with notification: Notification)
    {
        guard let session = notification.object as? UISceneSession, let windowScene = self.view.window?.windowScene, session.scene == windowScene else { return }
        Logger.main.info("Discarding current scene session, quitting emulation for game")
        
        //self.updateAutoSaveState()
        self.emulatorCore?.stop() // Required to ensure data isn't corrupted due to starting new game before previous EmulatorBridge state is reset.
    }
    
    @objc func sceneKeyboardFocusDidChange(with notification: Notification)
    {
        guard let scene = notification.object as? UIWindowScene, scene == self.view.window?.windowScene else { return }
        guard let externalDisplayScene = UIApplication.shared.externalDisplayScene else { return }
        
        if scene.hasKeyboardFocus
        {
            self.connectExternalDisplay(for: externalDisplayScene)
            
            if self.presentedViewController == nil
            {
                self.startGameActivity()
            }
        }
        else
        {
            // DON'T disconnect, only connect when active (so it stays connected to last active scene)
        }
    }
    
    @objc func keyboardDidShow(with notification: Notification)
    {
        guard let inputView = self.controllerView.inputView else { return }
        
        // Using keyboard game controller, so add gesture recognizers to keyboard.
//        for gestureRecognizer in self.menuButtonKeyboardGestureRecognizers
//        {
//            inputView.addGestureRecognizer(gestureRecognizer)
//        }
    }
    
    @objc func keyboardDidChangeFrame(with notification: Notification)
    {
        self.keyboardDidShow(with: notification)
    }
}

//MARK: - Emulation -
private extension GameViewController
{
    func quitEmulation()
    {
        if let presentedViewController = self.presentedViewController
        {
            presentedViewController.dismiss(animated: true) {
                self.quitEmulation()
            }
            
            return
        }
        
        self.emulatorCore?.stop()
        self.game = nil
        
        // Make sure split view controller doesn't accidentally re-appear.
        self.controllerView.resignFirstResponder()
        
        if self.isGameScene
        {
            guard let session = self.view.window?.windowScene?.session else { return }
            UIApplication.shared.requestSceneSessionDestruction(session, options: nil) { error in
                Logger.main.error("Failed to close game window. \(error.localizedDescription, privacy: .public)")
            }
        }
        else
        {
            self.performSegue(withIdentifier: "showGamesViewController", sender: nil)
        }
        
        self.stopGameActivity()
    }
}

//MARK: - GameViewControllerDelegate -
/// GameViewControllerDelegate
extension GameViewController: GameViewControllerDelegate
{
    
}


//MARK: - Handoff -
extension GameViewController: NSUserActivityDelegate
{
    func prepareForHandoff()
    {
        guard !self.isContinuingHandoff else { return }
        self.isContinuingHandoff = true
        
        self.updateGameViews()
    }
    
    func finishHandoff()
    {
        guard self.isContinuingHandoff else { return }
        self.isContinuingHandoff = false
        
        self.updateGameViews()
    }
    
    func startGameActivity()
    {
        
    }
    
    func pauseGameActivity()
    {
        
    }
    
    func stopGameActivity()
    {
        self.view.window?.windowScene?.userActivity = nil
    }
    
    func userActivity(_ userActivity: NSUserActivity, didReceive inputStream: InputStream, outputStream: OutputStream)
    {
        
    }
}

private extension GameViewController
{
    func connectExternalDisplay(for scene: ExternalDisplayScene)
    {
        // hasKeyboardFocus is false when enabling AirPlay via Control Center, so can't rely on that.
        // guard let windowScene = self.view.window?.windowScene, windowScene.hasKeyboardFocus else { return }
        
        // We need to receive gameViewController(_:didUpdateGameViews:) callback.
        scene.gameViewController.delegate = self
                
        //self.updateControllerSkin()
        
        // Implicitly called from updateControllerSkin()
        // self.updateExternalDisplay()
        
        self.updateGameViews()
    }
    
    func updateExternalDisplay()
    {
        guard let scene = UIApplication.shared.externalDisplayScene, scene.gameViewController.delegate === self else { return }
        
        if scene.game?.fileURL != self.game?.fileURL
        {
            scene.game = self.game
        }
        
//        var controllerSkin: ControllerSkinProtocol?
//        
//        if let game = self.game, let system = System(gameType: game.type), let traits = scene.gameViewController.controllerView.controllerSkinTraits
//        {
//            //TODO: Support per-game AirPlay skins
//            if let preferredControllerSkin = Settings.preferredControllerSkin(for: system, traits: traits, forExternalController: false), preferredControllerSkin.supports(traits)
//            {
//                // Use preferredControllerSkin directly.
//                controllerSkin = preferredControllerSkin
//            }
//            else if let standardSkin = DeltaCore.ControllerSkin.standardControllerSkin(for: game.type), standardSkin.supports(traits)
//            {
//                if standardSkin.hasTouchScreen(for: traits)
//                {
//                    // Only use TouchControllerSkin for standard controller skins with touch screens.
//                    
//                    var touchControllerSkin = DeltaCore.TouchControllerSkin(controllerSkin: standardSkin)
//                    touchControllerSkin.screenLayoutAxis = Settings.features.dsAirPlay.layoutAxis
//
//                    if Settings.features.dsAirPlay.topScreenOnly
//                    {
//                        touchControllerSkin.screenPredicate = { !$0.isTouchScreen }
//                    }
//
//                    controllerSkin = touchControllerSkin
//                }
//                else
//                {
//                    controllerSkin = standardSkin
//                }
//            }
//        }
        
//        scene.gameViewController.controllerView.controllerSkin = controllerSkin
        
        // Implicitly called when assigning controllerSkin.
        // self.updateExternalDisplayGameViews()
    }
    
    func updateExternalDisplayGameViews()
    {
        guard let scene = UIApplication.shared.externalDisplayScene, let emulatorCore = self.emulatorCore, scene.gameViewController.delegate === self else { return }
        
        for gameView in scene.gameViewController.gameViews
        {
            emulatorCore.add(gameView)
            gameView.exclusiveVideoManager = emulatorCore.videoManager
            
            // GameView must layout subviews after resetting EAGLContext before it can render frames.
            // Fixes external display screen sometimes not updating when switching back to paused game.
            gameView.setNeedsLayout()
            gameView.layoutIfNeeded()
        }
    }
    
    func disconnectExternalDisplay(for scene: ExternalDisplayScene)
    {
        if scene.gameViewController.delegate === self
        {
            scene.gameViewController.delegate = nil
        }
        
        for gameView in scene.gameViewController.gameViews
        {
            self.emulatorCore?.remove(gameView)
        }
        
        //self.updateControllerSkin() // Reset TouchControllerSkin + GameViews
        self.updateGameViews() // Ensure we re-enable GameView and hide AirPlay message.
    }
}

//MARK: - Controllers -
private extension GameViewController
{
    func updateGameViews()
    {
        if self.isContinuingHandoff
        {
            // Continuing from Handoff which may take a while, so hide all views.
            for gameView in self.gameViews
            {
                gameView.isEnabled = false
                gameView.isHidden = true
            }
        }
        else if UIApplication.shared.isExternalDisplayConnected
        {
            // AirPlaying, hide all (non-touch) screens.
            
            if let traits = self.controllerView.controllerSkinTraits,
               let supportedTraits = self.controllerView.controllerSkin?.supportedTraits(for: traits),
               let screens = self.controllerView.controllerSkin?.screens(for: supportedTraits)
            {
                for (screen, gameView) in zip(screens, self.gameViews)
                {
                    gameView.isEnabled = screen.isTouchScreen
                    
                    if gameView == self.gameView && !(screen.isTouchScreen)
                    {
                        // Always show AirPlay indicator on self.gameView, unless it is a touch screen AND we're only AirPlaying top screen.
                        gameView.isAirPlaying = true
                        gameView.isHidden = false
                    }
                    else
                    {
                        gameView.isAirPlaying = false
                        gameView.isHidden = !screen.isTouchScreen
                    }
                }
            }
            else
            {
                // Either self.controllerView.controllerSkin is `nil`, or it doesn't support these traits.
                // Most likely this system only has 1 screen, so just hide self.gameView.
                
                self.gameView.isEnabled = false
                self.gameView.isHidden = false
                self.gameView.isAirPlaying = true
            }
        }
        else
        {
            // Not AirPlaying, show all screens.
            
            if let traits = self.controllerView.controllerSkinTraits,
               let supportedTraits = self.controllerView.controllerSkin?.supportedTraits(for: traits),
               let screens = self.controllerView.controllerSkin?.screens(for: supportedTraits)
            {
                for (screen, gameView) in zip(screens, self.gameViews)
                {
                    gameView.isAirPlaying = false
                    
                    if let outputFrame = screen.outputFrame, outputFrame.isEmpty
                    {
                        // Frame is empty, so always disable it,
                        gameView.isEnabled = false
                        gameView.isHidden = true
                    }
                    else
                    {
                        gameView.isEnabled = true
                        gameView.isHidden = false
                    }
                }
            }
            else
            {
                for gameView in self.gameViews
                {
                    gameView.isEnabled = true
                    gameView.isHidden = false
                    gameView.isAirPlaying = false
                }
            }
        }
    }
}

//MARK: - Audio -
/// Audio
private extension GameViewController
{
    func updateAudio()
    {
        // Configure audio session for gameplay
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }

        self.emulatorCore?.audioManager.respectsSilentMode = false
    }
}

//MARK: - Sustain Buttons -
private extension GameViewController
{
    func showSustainButtonView()
    {
        guard let gameController = self.pausingGameController else { return }
        
        self.isSelectingSustainedButtons = true
        
        let sustainInputsMapping = SustainInputsMapping(gameController: gameController)
        gameController.addReceiver(self, inputMapping: sustainInputsMapping)
        
        let blurEffect = self.sustainButtonsBlurView.effect
        self.sustainButtonsBlurView.effect = nil
        
        self.sustainButtonsContentView.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.sustainButtonsBlurView.effect = blurEffect
        } completion: { _ in
            self.controllerView.becomeFirstResponder()
        }
    }
    
    func hideSustainButtonView()
    {
        guard let gameController = self.pausingGameController else { return }
        
        self.isSelectingSustainedButtons = false
        
        self.updateControllers()
        self.sustainInputsMapping = nil
        
        // Activate all sustained inputs, since they will now be mapped to game inputs.
        for (input, value) in self.inputsToSustain
        {
            gameController.sustain(input, value: value)
        }
        
        let blurEffect = self.sustainButtonsBlurView.effect
        
        UIView.animate(withDuration: 0.4, animations: {
            self.sustainButtonsBlurView.effect = nil
        }) { (finished) in
            self.sustainButtonsContentView.isHidden = true
            self.sustainButtonsBlurView.effect = blurEffect
        }
        
        self.inputsToSustain = [:]
    }
}
