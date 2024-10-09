//
//  LoadingPage.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 07/10/24.
//

import SwiftUI

struct LoadingPage: View {
    var body: some View {
        ZStack {
            Color(hex: "F9F6F4")
                .ignoresSafeArea()
            
            Image("beeHive")
            
            VStack {
                Image("Bee")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80)
                    .rotationEffect(.degrees(35))
                Text("Loading...")
                    .font(.poppins(.bold, .largeTitle))
                    .multilineTextAlignment(.center)
                Text("With Vocabeez, don't be lazy again to\nlearn new words.")
                    .font(.poppins(.regular, .headline))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoadingPage()
}
