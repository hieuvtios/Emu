//
//  LayoutManager.swift
//  GameEmulator
//
//  Created by Hieu Vu on 10/8/25.
//

import UIKit

// MARK: - Layout Manager
class LayoutManager {
    private weak var viewController: GameViewController?
    
    init(viewController: GameViewController) {
        self.viewController = viewController
    }
    
    func layoutGameViewAndController() {
        guard let vc = viewController else { return }
        
        let safeAreaInsets = vc.view.safeAreaInsets
        let screenSize = vc.view.bounds.size
        
        // Calculate controller dimensions
        let controllerFrame = calculateControllerFrame(screenSize: screenSize)
        
        // Calculate game view dimensions
        let gameViewFrame = calculateGameViewFrame(
            screenSize: screenSize,
            safeAreaInsets: safeAreaInsets,
            controllerHeight: controllerFrame.height
        )
        
        // Apply frames
        if !vc.controllerView.isHidden {
            vc.controllerView.frame = controllerFrame
        }
        
        if let gameView = vc.gameViews.first {
            gameView.frame = gameViewFrame
        }
        
        // Refresh rendering if needed
        if let core = vc.emulatorCore, core.state != .running {
            core.videoManager.render()
        }
    }
    
    private func calculateControllerFrame(screenSize: CGSize) -> CGRect {
        guard let vc = viewController, !vc.controllerView.isHidden else { return .zero }
        
        let intrinsicSize = vc.controllerView.intrinsicContentSize
        guard intrinsicSize.height != UIView.noIntrinsicMetric,
              intrinsicSize.width != UIView.noIntrinsicMetric else { return .zero }
        
        let height = (screenSize.width / intrinsicSize.width) * intrinsicSize.height
        return CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height)
    }
    
    private func calculateGameViewFrame(screenSize: CGSize, safeAreaInsets: UIEdgeInsets, controllerHeight: CGFloat) -> CGRect {
        guard let vc = viewController else { return .zero }
        
        let availableWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right
        let availableHeight = screenSize.height - controllerHeight - safeAreaInsets.top - safeAreaInsets.bottom
        
        let gameSize = vc.emulatorCore?.preferredRenderingSize ?? CGSize(width: 256, height: 224)
        let aspectRatio = gameSize.width / gameSize.height
        
        var width = availableWidth
        var height = width / aspectRatio
        
        if height > availableHeight {
            height = availableHeight
            width = height * aspectRatio
        }
        
        let x = safeAreaInsets.left + (availableWidth - width) / 2
        let y = safeAreaInsets.top
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
