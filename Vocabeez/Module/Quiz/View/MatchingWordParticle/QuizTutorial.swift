//
//  QuizTutorial.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

struct QuizTutorial: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Let's Match It Up!")
                .font(.poppins(.bold, .largeTitle))
                .foregroundStyle(Color(hex: "525A67"))
            
            Image("QuizTips")
                .padding(.bottom, 30)
            
            Text("To get the right pairs…\nJust click each item on the left to its matching\npartner on the right.")
                .font(.poppins(.medium, .footnote))
                .foregroundStyle(Color(hex: "525A67"))
                .padding(.horizontal, -15)
            
            Button {
                HapticFeedback.medium.impact()
                isPresented = false
            } label: {
                Text("Got it")
                    .font(.poppins(.semiBold, .headline))
                    .foregroundColor(Color(hex: "ECE3DA"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 11)
                        .fill(Color(hex: "3F679F")))
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isPresented = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                QuizTutorial(isPresented: $isPresented)
                    .frame(width: 340)
            }
        }
    }
    
    return PreviewWrapper()
}
