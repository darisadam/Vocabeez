//
//  MatchButton.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 28/09/24.
//

import SwiftUI

struct MatchButton: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let borderColor: QuizButtonBorderColor
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(.medium, .subheadline))
                .foregroundStyle(Color(hex: "#525A67"))
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.2)
                .lineLimit(4)
                .padding()
                .frame(width: width, height: height)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(quizButtonBorderColor, lineWidth: lineWidth)
                    .shadow(color: quizButtonBorderColor, radius: shadowRadius, x: 0, y: 3))
        }
        .disabled(isDisabled)
    }
    
    private var quizButtonBorderColor: Color {
        switch borderColor {
        case .normal:
            return Color(hex: "181A20")
        case .pressed:
            return Color(hex: "3F679F")
        case .correct:
            return Color(hex: "29A77B")
        case .incorrect:
            return Color(hex: "FF6168")
        }
    }
    
    private var lineWidth: CGFloat {
        switch borderColor {
        case .normal:
            return 1.0
        case .pressed, .correct, .incorrect:
            return 2.5
        }
    }
    
    private var shadowRadius: CGFloat {
        switch borderColor {
        case .normal:
            return 2
        case .pressed, .correct, .incorrect:
            return 3
        }
    }
}

#Preview {
    let quizVM = QuizViewModel()
    
    ForEach(quizVM.displayedPhrases) { item in
        MatchButton(
            title: item.text,
            width: 183,
            height: 79,
            borderColor: item.borderColor,
            isDisabled: false,
            action: { quizVM.selectItem(item.id) }
        )
    }
}
