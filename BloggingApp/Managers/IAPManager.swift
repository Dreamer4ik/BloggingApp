//
//  IAPManager.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import Foundation
import Purchases

final class IAPManager{
    static let shared = IAPManager()
    //RevenueCat Shared secret
    //secret from dev acc
    private init() {
        
    }
    
    func isPremium() -> Bool {
        return false
    }
    
    func subscribe() {
        
    }
    
    func restorePurchases() {
        
    }
}
