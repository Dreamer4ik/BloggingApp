//
//  IAPManager.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import Foundation
import Purchases
import StoreKit

final class IAPManager{
    static let shared = IAPManager()
    
    private var postEligibleViewDate: Date?
    
    //RevenueCat Shared secret
    //secret from dev acc
    private init() {
        
    }
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
    
    public func getSubscriptionStatuts(completion: ((Bool) -> Void)?) {
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                      return
                  }
            if entitlements.all["Premium"]?.isActive == true {
                print("Got updated status of subscribed")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            }
            else {
                print("Got updated status of NOT subscribed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }
    
    public func fetchPackages(completion: @escaping(Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                      completion(nil)
                      return
                  }
            completion(package)
        }
    }
    
    public func subscribe(package: Purchases.Package,
                          completion: @escaping (Bool) -> Void) {
        guard !isPremium() else {
            print("User already subscribed")
            completion(true)
            return
        }
        
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCanceled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCanceled else {
                      return
                  }
            
            switch transaction.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                if entitlements.all["Premium"]?.isActive == true {
                    print("Purchased!")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                }
                else {
                    print("Purchase failed")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default case")
            }
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                      return
                  }
            if entitlements.all["Premium"]?.isActive == true {
                print("Restored success")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            }
            else {
                print("Restored faillure")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }
        }
    }
}


// MARK: Track Post Views
// MARK: after this time postEligibleViewDate not working before relaunch
extension IAPManager {
    var canViewPost: Bool {
        if isPremium() {
            return true
        }
        guard let date = postEligibleViewDate else {
            return true
        }
        UserDefaults.standard.set(0, forKey: "post_views")
        return Date() >= date
    }
    
    public func logPostViewed() {
        let total = UserDefaults.standard.integer(forKey: "post_views")

        UserDefaults.standard.set(total+1, forKey: "post_views")
        
        
        if total == 2{
            let hour: TimeInterval = 60 * 60
            // /60 because does not have Acc Developer for Purchase and normal test with /60
            postEligibleViewDate = Date().addingTimeInterval(hour / 60 )
//            postEligibleViewDate = Date().addingTimeInterval(hour * 24)
        }
    }
}
