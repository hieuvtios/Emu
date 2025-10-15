//
//  ATT.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 15/10/25.
//
import Foundation
import AppTrackingTransparency
import AdSupport

enum ATTAuthorization {
    static func requestIfNeeded(onCompleteATTTracking: @escaping () -> ()) {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            onCompleteATTTracking()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                onCompleteATTTracking()
            }
        }
    }
}
