//
//  HapticFeedback.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 01/10/24.
//

import Foundation

import SwiftUI

enum HapticFeedback {
    case light, medium, heavy
    
    func impact() {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.impactOccurred(intensity: 1.0)
    }
    
    private var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        }
    }
}
