//
//  RemoteConfigManager.swift
//  AINote
//
//  Created by Đỗ Việt on 18/6/25.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigValueKey: String {
    case is_show_ads_open
    case is_show_ads_banner
    case is_show_ads_banner_ingame
    case is_show_inter_ads
    case time_show_inter_ads
    case number_show_inter_ads
    case time_between_inter_ads
    case is_show_onboarding_rating
    case is_limit_play_game
    case is_user_guide_tips
    case is_show_flow_add_game
}

//final class RemoteConfigManager {
//    static let shared = RemoteConfigManager()
//
//    var loadingDoneCallback: (() -> Void)?
//    var fetchComplete = false
//    var isDebug = true
//    
//    private var remoteConfig = RemoteConfig.remoteConfig()
//    
//    private init() {
//        setupConfigs()
//        loadDefaultValues()
//        setupListener()
//    }
//    
//    func setupConfigs() {
//        let settings = RemoteConfigSettings()
//        // fetch interval that how frequent you need to check updates from the server
//        settings.minimumFetchInterval = isDebug ? 0 : 43200
//        remoteConfig.configSettings = settings
//    }
//    
//    /**
//     In case firebase failed to fetch values from the remote server due to internet failure
//     or any other circumstance, In order to run our application without any issues
//     we have to set default values for all the variables that we fetches
//     from the remote server.
//     If you have higher number of variables in use, you can use info.plist file
//     to define the defualt values as well.
//     */
//    func loadDefaultValues() {
//        let appDefaults: [String: Any?] = [
//            RemoteConfigValueKey.is_show_ads_open.rawValue: true,
//            RemoteConfigValueKey.is_show_ads_banner.rawValue: true,
//            RemoteConfigValueKey.is_show_ads_banner_ingame.rawValue: true,
//            RemoteConfigValueKey.is_show_inter_ads.rawValue: true,
//            RemoteConfigValueKey.time_show_inter_ads.rawValue: 120,
//            RemoteConfigValueKey.number_show_inter_ads.rawValue: 5,
//            RemoteConfigValueKey.time_between_inter_ads.rawValue: 20,
//            RemoteConfigValueKey.is_show_onboarding_rating.rawValue: true,
//            RemoteConfigValueKey.is_limit_play_game.rawValue: 10,
//            RemoteConfigValueKey.is_user_guide_tips.rawValue: true,
//            RemoteConfigValueKey.is_show_flow_add_game.rawValue: true
//        ]
//        remoteConfig.setDefaults(appDefaults as? [String: NSObject])
//    }
//    
//    /**
//     Setup listner functions for frequent updates
//     */
//    func setupListener() {
//        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard configUpdate != nil else {
//                print("REMOTE CONFIG ERROR")
//                return
//            }
//            
//            self.remoteConfig.activate { changed, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    print("REMOTE CONFIG activation state change \(changed)")
//                }
//            }
//        }
//    }
//    
//    /**
//     Function for fectch values from the cloud
//     */
//    func fetchCloudValues() {
//        remoteConfig.fetch { [weak self] (status, error) -> Void in
//            guard let self = self else { return }
//            
//            if status == .success {
//                self.remoteConfig.activate { _, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//                    self.fetchComplete = true
//                    print("Remote config fetch success")
//                    DispatchQueue.main.async {
//                        self.loadingDoneCallback?()
//                    }
//                }
//            } else {
//                print("Remote config fetch failed")
//                DispatchQueue.main.async {
//                    self.loadingDoneCallback?()
//                }
//            }
//        }
//    }
//}
//
//extension RemoteConfigManager {
//    func bool(forKey key: RemoteConfigValueKey) -> Bool {
//        return remoteConfig[key.rawValue].boolValue
//    }
//    
//    func string(forKey key: RemoteConfigValueKey) -> String {
//        return remoteConfig[key.rawValue].stringValue
//    }
//    
//    func double(forKey key: RemoteConfigValueKey) -> Double {
//        return remoteConfig[key.rawValue].numberValue.doubleValue
//    }
//    
//    func int(forKey key: RemoteConfigValueKey) -> Int {
//        return remoteConfig[key.rawValue].numberValue.intValue
//    }
//}

