//
//  QuizModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 29/09/24.
//

import SwiftUI

struct QuizItem: Identifiable {
    let id = UUID()
    let text: String
    let isPhrase: Bool
    let matchId: UUID
    var borderColor: QuizButtonBorderColor = .normal
    var isDisabled: Bool = false
}

enum QuizButtonBorderColor {
    case normal, pressed, correct, incorrect
    
    var color: Color {
        switch self {
        case .normal: return Color(hex: "181A20")
        case .pressed: return Color(hex: "3F679F")
        case .correct: return Color(hex: "29A77B")
        case .incorrect: return Color(hex: "FF6168")
        }
    }
}
