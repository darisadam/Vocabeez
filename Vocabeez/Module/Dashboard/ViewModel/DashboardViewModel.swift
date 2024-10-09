//
//  DashboardViewModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var showFirstTimeAlert: Bool = false
    var learnedVocab = VocabeeStorage.structArrayData(VocabList.self, forKey: .LEARNED_VOCAB)
    
    func shouldShowFirstTimeAlert() -> Bool {
        let hasUsedPracticeFeature = VocabeeStorage.getBool(forKey: .HAS_USED_PRACTICE_FEATURE) ?? false
        return !hasUsedPracticeFeature && learnedVocab.isEmpty
    }
    
    func dismissFirstTimeAlert() {
        showFirstTimeAlert = false
    }
}
