//
//  OnboardingView.swift
//  Vocabee
//
//  Created by Sry Tambunan on 04/10/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage: String = "WelcomeView"

    var body: some View {
        VStack {
            switch currentPage {
            case "WelcomeView":
                WelcomeView(currentPage: $currentPage)
            case "LearningGoalsView":
                LearningGoalsView(currentPage: $currentPage)
            case "GetReadyView":
                GetReadyView(currentPage: $currentPage)
            case "BenefitView":
                WhatWillYouGetView(currentPage: $currentPage, isOnboardingCompleted: $isOnboardingCompleted)
            default:
                WelcomeView(currentPage: $currentPage)
            }
        }
    }
}
