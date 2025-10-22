import SwiftUI
import RevenueCat

class RevenueCatManager: ObservableObject {
    // Published properties to track state
    @AppStorage("isSubscribed") var isSubscribed: Bool = false
    @Published var currentEntitlements: [String: Bool] = [:]
    @Published var customerInfo: CustomerInfo?
    @Published var isLoading: Bool = false
    @Published var currentPackage = ""
    @Published var revenueCatUserId = ""
    
    let idOfferings = "default"
    let kRevenueEntitlementId = "premium"
    
    // Singleton instance
    static let shared = RevenueCatManager()
    
    private init() {
        configureRevenueCat()
        updateCustomerInfo()
    }
    
    // MARK: - Configuration
    
    private func configureRevenueCat() {
        // Replace with your actual API key
        Purchases.configure(withAPIKey: Constants.revenueCatID)
        
        // Optional: Set user ID for better tracking
        if let userId = getUserId() {
            Purchases.shared.logIn(userId) { customerInfo, created, error in
                if let error = error {
                    print("Error logging in: \(error.localizedDescription)")
                    return
                }
                
                self.customerInfo = customerInfo
                self.updateEntitlements(with: customerInfo)
            }
        }
    }
    
    private func getUserId() -> String? {
        // Implement your user ID retrieval logic here
        // For example, from UserDefaults or your authentication system
        return nil
    }
    
    // MARK: - Public Methods
    
    /// Purchase a specific package
    func purchase(package: Package, completion: @escaping (Bool, Error?) -> Void) {
        isLoading = true
        
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            self.isLoading = false
            
            if let error = error {
                print("Purchase failed: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if userCancelled {
                print("Purchase was cancelled by user")
                completion(false, nil)
                return
            }

            // Update entitlements
            self.customerInfo = customerInfo
      
            self.updateEntitlements(with: customerInfo)
            
            completion(true, nil)
        }
    }

    // Helper function to extract currency code from localized price string
    private func extractCurrencyCode(from priceString: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        // Try common locales to extract currency
        let commonLocales = [
            Locale.current,
            Locale(identifier: "en_US"),
            Locale(identifier: "en_GB"),
            Locale(identifier: "de_DE"),
            Locale(identifier: "fr_FR"),
            Locale(identifier: "ja_JP")
        ]
        
        for locale in commonLocales {
            formatter.locale = locale
            if let _ = formatter.number(from: priceString) {
                return locale.currencyCode
            }
        }
        
        return nil
    }
    
    /// Restore previous purchases
    func restorePurchases(completion: @escaping (Bool, Error?) -> Void) {
        isLoading = true
        
        Purchases.shared.restorePurchases { (customerInfo, error) in
            self.isLoading = false
            
            if let error = error {
                print("Restore failed: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            // Update entitlements after restore
            self.customerInfo = customerInfo
            self.updateEntitlements(with: customerInfo)
            
            completion(true, nil)
        }
    }
    
    /// Check if user has a specific entitlement
    func checkEntitlement(entitlement: String) -> Bool {
        return currentEntitlements[entitlement] ?? false
    }
    
    /// Update customer info and entitlements
    func updateCustomerInfo() {
        isLoading = true
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isLoading = false
            
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
                self.updateEntitlements(with: customerInfo)
                return
            }
            
            self.customerInfo = customerInfo
            self.updateEntitlements(with: customerInfo)
            
            if let userId = customerInfo?.id {
                self.revenueCatUserId = userId
            }
        }
    }
    
    // MARK: - Private Helpers
    private func updateEntitlements(with customerInfo: CustomerInfo?) {
        guard let customerInfo = customerInfo else { return }
        
        // Reset entitlements
        currentEntitlements = [:]
        
        // Update subscription status
        isSubscribed = customerInfo.entitlements.active.isEmpty == false
        
        currentPackage = customerInfo.activeSubscriptions.first ?? ""
        
        for (entitlement, info) in customerInfo.entitlements.all {
            currentEntitlements[entitlement] = info.isActive
        }
    }
    
    func convertDateToISO8601String(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Optional, set to UTC
        
        return dateFormatter.string(from: date)
    }
    
    func getPackages(_ offeringIdentifier: String) async -> (packages: [Package], error: RevenueCatError?) {
        return await withCheckedContinuation { continuation in
            Purchases.shared.getOfferings { offering, error in
                if let error {
                    continuation.resume(returning: ([], .error(error)))
                } else {
                    let packages: [Package] = offering?.offering(identifier: offeringIdentifier)?.availablePackages ?? []
                    continuation.resume(returning: (packages, nil))
                }
            }
        }
    }
}

enum RevenueCatError: Error, CustomDebugStringConvertible {
    case waiting, error(NSError)
    var debugDescription: String {
        switch self {
        case .waiting:
            return "Waiting purchase or restore"
        case .error(let error):
            return error.localizedDescription
        }
    }
}


// MARK: - Example Usage Extension

extension RevenueCatManager {
    
    /// Example method to check premium status
    func isPremium() -> Bool {
        return checkEntitlement(entitlement: "premium")
    }
    
    /// Example method for purchasing a specific offering
    func purchasePremium(completion: @escaping (Bool, Error?) -> Void) {
        Purchases.shared.getOfferings { (offerings, error) in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let offering = offerings?.offering(identifier: "default") else {
                completion(false, NSError(domain: "RevenueCatManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "default offering not found"]))
                return
            }
            
            guard let monthlyPackage = offering.package(identifier: "monthly") else {
                completion(false, NSError(domain: "RevenueCatManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Monthly package not found"]))
                return
            }
            
            self.purchase(package: monthlyPackage, completion: completion)
        }
    }
    
    func handlerPurchaseComplete(with customerInfo: CustomerInfo) {
        self.customerInfo = customerInfo
        self.updateEntitlements(with: customerInfo)
    }
}
