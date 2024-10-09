//
//  ContentView.swift
//  OnboardingVocabee
//
//  Created by Sry Tambunan on 29/09/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentPage: String
    @State private var isActive = false // State untuk mengontrol perpindahan otomatis

    var body: some View {
        VStack {
            Spacer()
            Image("LogoApp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("BcWelcomeView")  // Background halaman pertama
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onAppear {
            // Menunda selama 2 detik sebelum berpindah ke halaman kedua
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isActive = true
            }
        }
        // Kondisi perpindahan otomatis setelah 2 detik
        .fullScreenCover(isPresented: $isActive) {
            OnboardingSecondPage(currentPage: $currentPage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingSecondPage: View {
    @Binding var currentPage: String

    var body: some View {
        ZStack {
            Image("BCWelcome")  // Mengganti background dengan aset "BcWelcome"
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BiruTua"))

                Text("Transform the way you learn vocabulary, where every context brings new meaning.")
                    .font(.body)
                    .foregroundColor(Color("BiruTua"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Image("Bee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)

                Spacer()

                Text("Vocabeez helps you nail the right word for every situation")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundColor(Color("BiruTua"))
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Memastikan seluruh area button bisa di klik
                Button(action: {
                    HapticFeedback.medium.impact()
                    currentPage = "LearningGoalsView"
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Button"))
                        .cornerRadius(11)
                        .contentShape(Rectangle()) // Memastikan seluruh area button bisa di klik
                }
                .buttonStyle(PlainButtonStyle()) // Menghilangkan gaya default button
                .padding(.horizontal, 20)
                .padding(.bottom, -20)

                Spacer(minLength: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentPage: .constant("WelcomeView"))
    }
}
