//
//  FirstTimeAlert.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

struct FirstTimeAlert: View {
    let dismissAction: () -> Void
    
    var body: some View {
        VStack {
            Image("Bee")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .rotationEffect(.degrees(35))
            
            Text("Before you jump into the quiz, let’s go over\nsome vocab first! Ready to learn how\nthese words fit into different contexts?")
                .font(.poppins(.medium, .headline))
                .foregroundStyle(Color(hex: "525A67"))
                .multilineTextAlignment(.center)
            
            Text("Let’s explore!")
                .font(.poppins(.semiBold, .headline))
                .foregroundStyle(.beeBlack)
                .padding(.bottom, 50)
            
            Button(action: {
                HapticFeedback.medium.impact()
                dismissAction()
            }) {
                Text("Today’s Vocab")
                    .font(.poppins(.semiBold, .headline))
                    .foregroundStyle(.beeBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 11)
                        .fill(Color(hex: "FACB73"))
                        .shadow(color: Color(hex: "C39430"), radius: 0.1, x: 0, y: 5))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .padding(.bottom, 50)
        .background(Color(hex: "ECE3DA"))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

#Preview {
    FirstTimeAlert(dismissAction: {})
}
