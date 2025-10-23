//
//  UserDefaultsUnityManager.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 13/10/25.
//

import Foundation

struct UserDefaultsUnityManager<T> {
    private let userDefaults: UserDefaults
    private let key: String

    init(userDefaults: UserDefaults = UserDefaults.standard,
         key: String) {
        self.userDefaults = userDefaults
        self.key = key
    }

    func save(data: T) {
        userDefaults.set(data, forKey: key)
    }

    func read() -> T? {
        return userDefaults.value(forKey: key) as? T
    }

    func delete() {
        userDefaults.removeObject(forKey: key)
    }
}

enum UserDefaultsKeys: String {
    case firstTimeOpen
    case purchase
}

enum UserDefaultsOrganizer {
    static var isFirstTimeOpen = UserDefaultsUnityManager<Bool>(key: UserDefaultsKeys.firstTimeOpen.rawValue)
    static var isPurchased = UserDefaultsUnityManager<Bool>(key: UserDefaultsKeys.purchase.rawValue)
}

final class UserDefaultsManager: ObservableObject {
    
    static let shared = UserDefaultsManager()
    
    private init() {
        self.isFirstTimeOpen = UserDefaultsOrganizer.isFirstTimeOpen.read() ?? true
        self.isPurchased = UserDefaultsOrganizer.isPurchased.read() ?? false
    }

    // Published để View tự cập nhật khi đổi
    @Published var isFirstTimeOpen: Bool {
        didSet {
            UserDefaultsOrganizer.isFirstTimeOpen.save(data: isFirstTimeOpen)
        }
    }
    
    @Published var isPurchased: Bool {
        didSet {
            UserDefaultsOrganizer.isPurchased.save(data: isPurchased)
        }
    }
}
