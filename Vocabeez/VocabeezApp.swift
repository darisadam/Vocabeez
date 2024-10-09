//
//  VocabeeApp.swift
//  Vocabee
//
//  Created by Sry Tambunan on 23/09/24.
//

import SwiftUI

@main
struct VocabeezApp: App {
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                DashboardView()
                    .preferredColorScheme(.light)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .preferredColorScheme(.light)
            }
        }
    }
}
