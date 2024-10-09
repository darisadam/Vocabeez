//
//  ChartView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import SwiftUI

struct ChartView: View {
    @State private var hasUsedPracticeFeature: Bool = false
    
    var body: some View {
        Group {
            if hasUsedPracticeFeature {
                ReturningUserChart()
            } else {
                FirstUserChart()
            }
        }
        .onAppear {
            // Update the state when the view appears
            hasUsedPracticeFeature = VocabeeStorage.getBool(forKey: .HAS_USED_PRACTICE_FEATURE) ?? false
        }
    }
}

#Preview {
    ChartView()
}
