//
//  HapticsManager.swift
//  BloggingApp
//
//  Created by Ivan on 20.01.2022.
//

import Foundation
import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
   private init() {
        
    }
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
