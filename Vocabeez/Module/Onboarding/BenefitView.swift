//
//  BenefitView.swift
//  Vocabee
//
//  Created by Sry Tambunan on 29/09/24.
//

import SwiftUI

struct WhatWillYouGetView: View {
    @Binding var currentPage: String
    @Binding var isOnboardingCompleted: Bool  // Binding to track if onboarding is completed

    var body: some View {
        VStack {
            // Header Section
            VStack(spacing: 5) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("What Will You Get")
                        .font(.title)
                        .foregroundColor(Color("BiruTua"))
                        .padding(.top, 70)
                        .frame(maxWidth: .infinity, alignment: .center)

                    ProgressBar(progressColor: Color("BiruTua"), backgroundColor: Color(UIColor.systemGray4), progress: 1)
                        .padding(.top, 20)

                    HStack {
                        Image("Bee")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 20)

                        Text("We’ll remind you to practice till it becomes a habit!")
                            .font(.system(size: 16, weight: .medium))
                            .padding()

                        Spacer()
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 5)

            Spacer(minLength: 30)

            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image("Understand")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Understand with Clarity")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Grasp the deeper meaning of words in any situation effortlessly.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, -230)
                .padding(.bottom, 10)

                HStack(spacing: 10) {
                    Image("Communicate")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Communicate with Precision")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Use the right word at the right time, no matter the conversation.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top,-145)
                .padding(.bottom, 80)

                // Feature Item 3
                HStack(spacing: 10) {
                    Image("Adapt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Adapt with Ease")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Practice regularly and track your progress as you improve.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top,-145)
                .padding(.bottom, 80)
            }
            .padding(.horizontal, 16)

            // Button
            Button(action: {
                HapticFeedback.medium.impact()
                isOnboardingCompleted = true  // Mark onboarding as completed
            }) {
                Text("Let’s Go")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Button"))
                    .cornerRadius(11)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 50)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// Preview
struct WhatWillYouGetView_Previews: PreviewProvider {
    static var previews: some View {
        WhatWillYouGetView(currentPage: .constant("BenefitView"), isOnboardingCompleted: .constant(false))
    }
}

