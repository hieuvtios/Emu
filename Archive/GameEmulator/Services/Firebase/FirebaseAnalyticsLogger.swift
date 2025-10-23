//
//  FirebaseAnalyticsLogger.swift
//  AINote
//
//  Created by Đỗ Việt on 8/6/25.
//

import FirebaseAnalytics

enum FirebaseEvent: String {
    case view_screen_loading
    case view_onboarding_start
    case view_onboarding_end
    case view_onboarding_rating
    case view_onboarding_paywall
    case view_inapp_paywall
    case view_home
    case view_guide
    case view_console
    case view_settings
    case click_add_import
    case view_ingame
    case view_ingame_menu
    case view_ingame_alert_autosave
    case alert_import_no_support
}

final class FirebaseAnalyticsLogger {
    // Singleton instance
    static let shared = FirebaseAnalyticsLogger()
    
    private init() {}
    
    private var eventCounts: [String: Int] = [:]
    
    func logEvent(_ event: FirebaseEvent, parameters: [String: Any]? = nil) {
        // Tăng đếm
        eventCounts[event.rawValue, default: 0] += 1
        let count = eventCounts[event.rawValue] ?? 1
        
        // Gộp parameter thêm count
        var mergedParams = parameters ?? [:]
        mergedParams["count"] = count
        
        Analytics.logEvent(event.rawValue, parameters: mergedParams)
        print("Event: \(event.rawValue) - count: \(count) - params: \(mergedParams)")
    }
}
