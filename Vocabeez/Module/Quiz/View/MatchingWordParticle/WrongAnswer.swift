//
//  WrongAnswer.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 30/09/24.
//

import SwiftUI

struct WrongAnswer: View {
    let wrongPair: (QuizItem, QuizItem)?
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wrong")
                        .font(.poppins(.semiBold, .title3))
                        .foregroundStyle(.white)
                    if let (phrase, meaning) = wrongPair {
                        Text("In this context, '\(phrase.text)' doesn't means '\(meaning.text)'.")
                            .font(.poppins(.regular, .subheadline))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            Button(action: {
                HapticFeedback.medium.impact()
                dismissAction()
            }) {
                Text("Try Again")
                    .font(.poppins(.semiBold, .headline))
                    .foregroundStyle(Color(hex: "FF6168"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(.white)
                    .cornerRadius(8)
            }
        }
        .padding(20)
        .padding(.bottom, 50)
        .background(Color(hex: "FF6168"))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

#Preview {
    WrongAnswer(wrongPair: (
        QuizItem(text: "Charge", isPhrase: true, matchId: UUID()),
        QuizItem(text: "To power or recharge", isPhrase: false, matchId: UUID())),
        dismissAction: {})
}
