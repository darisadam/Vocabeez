//
//  ChartViewModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 28/09/24.
//

import Foundation

class ReturningUserChartViewModel: ObservableObject {
    @Published var learnedVocabCount: Int
    @Published var contextCount: Int
    @Published var dataResult: VocabResult?
    
    init() {
        self.learnedVocabCount = VocabeeStorage.getInt(forKey: .LEARNED_VOCAB_COUNT)
        self.contextCount = VocabeeStorage.getInt(forKey: .LEARNED_CONTEXT_COUNT)
        self.dataResult = VocabeeStorage.structData(VocabResult.self, forKey: .RESULT_DATA)
        
        // Update dataResult if necessary
        if dataResult == nil || dataResult?.vocabTotal != learnedVocabCount || dataResult?.contextTotal != contextCount {
            dataResult = VocabResult(vocabTotal: learnedVocabCount, contextTotal: contextCount, score: QuizSummaryView().getScore)
            VocabeeStorage.setStruct(dataResult, forKey: .RESULT_DATA)
        }
    }
    
    // Increment contextCount by 1 after finishing PracticeView
    func incrementContextForPractice() {
        learnedVocabCount += 1
        saveLearnedVocab()
    }
    
    // Increment contextCount by number of quiz phrases after finishing QuizView
    func incrementContextForQuiz(by phrasesCount: Int) {
        contextCount += phrasesCount
        saveLearnedVocab()
    }
    
    private func saveLearnedVocab() {
        VocabeeStorage.set(value: learnedVocabCount, forKey: .LEARNED_VOCAB_COUNT)
        VocabeeStorage.set(value: contextCount, forKey: .LEARNED_CONTEXT_COUNT)
        dataResult = VocabResult(vocabTotal: learnedVocabCount, contextTotal: contextCount, score: QuizSummaryView().getScore)
        VocabeeStorage.setStruct(dataResult, forKey: .RESULT_DATA)
    }
    
    func makeAttributedString() -> AttributedString {
        var attributedString = AttributedString("Awesome! You've learned \(learnedVocabCount) vocabs in \(contextCount)\ncontexts. Keep going and boost your\nvocabulary in even more exciting contexts!")
        
        if let range = attributedString.range(of: "\(learnedVocabCount) vocabs") {
            attributedString[range].font = .poppins(.bold, .callout)
        }
        
        if let range = attributedString.range(of: "\(contextCount)\ncontexts") {
            attributedString[range].font = .poppins(.bold, .callout)
        }
        
        return attributedString
    }
}
