//
//  QuizViewModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 28/09/24.
//

import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var contextMatches: [ContextMatchData] = []
    @Published var displayedPhrases: [QuizItem] = []
    @Published var displayedMeanings: [QuizItem] = []
    @Published var selectedItemId: UUID?
    @Published var showWrongAnswerView = false
    @Published var currentWrongPair: (QuizItem, QuizItem)?
    @Published var correctPairsCount = 0
    @Published var isQuizInteractionDisabled = false
    @Published var isQuizFinished = false
    var numberOfAttempts = 0
    
    let getContext = VocabeeStorage.structData(VocabList.self, forKey: .SELECTED_VOCAB)
    
    init() {
        loadData()
        generateNewQuiz()
    }
    
    private func loadData() {
        let vocabEntries: [VocabList] = loadJSON("generalVocab.json")
        contextMatches = getContext?.context.map { $0.contextMatch } ?? vocabEntries.flatMap { $0.context.map { $0.contextMatch } }
        
        if contextMatches.isEmpty {
            contextMatches = vocabEntries.flatMap { $0.context.map { $0.contextMatch } }
        }
    }
    
    func generateNewQuiz() {
        let selectedQuizzes = Array(contextMatches.shuffled().prefix(5))
        var phrases: [QuizItem] = []
        var meanings: [QuizItem] = []
        
        for quiz in selectedQuizzes {
            let matchId = UUID()
            phrases.append(QuizItem(text: quiz.context, isPhrase: true, matchId: matchId))
            meanings.append(QuizItem(text: quiz.mean, isPhrase: false, matchId: matchId))
        }
        
        displayedPhrases = phrases.shuffled()
        displayedMeanings = meanings.shuffled()
        correctPairsCount = 0
        isQuizInteractionDisabled = false
        showWrongAnswerView = false
        currentWrongPair = nil
        selectedItemId = nil
        isQuizFinished = false
    }
    
    func selectItem(_ id: UUID) {
        guard !isQuizInteractionDisabled else { return }
        
        if let index = (displayedPhrases + displayedMeanings).firstIndex(where: { $0.id == id }) {
            let item = (displayedPhrases + displayedMeanings)[index]
            let isLeftSide = displayedPhrases.contains(where: { $0.id == id })
            
            if item.borderColor == .pressed {
                updateItemState(id, borderColor: .normal)
                if selectedItemId == id {
                    selectedItemId = nil
                }
            } else if let selectedItemId = selectedItemId {
                guard let selectedItem = (displayedPhrases + displayedMeanings).first(where: { $0.id == selectedItemId }),
                      selectedItem.borderColor == .pressed else {
                    return
                }
                
                let selectedIsLeftSide = displayedPhrases.contains(where: { $0.id == selectedItemId })
                
                if isLeftSide == selectedIsLeftSide {
                    updateItemState(selectedItemId, borderColor: .normal)
                    updateItemState(id, borderColor: .normal)
                    self.selectedItemId = nil
                } else if selectedItem.matchId == item.matchId {
                    // TRIGGER WHEN CONTEXT SELECTER IS CORRECT
                    numberOfAttempts += 1
                    updateItemState(selectedItemId, borderColor: .correct, isDisabled: true)
                    updateItemState(id, borderColor: .correct, isDisabled: true)
                    correctPairsCount += 1
                    checkQuizFinished()
                } else {
                    // TRIGGER WHEN CONTEXT SELECTER IS INCORRECT
                    numberOfAttempts += 1
                    updateItemState(selectedItemId, borderColor: .incorrect)
                    updateItemState(id, borderColor: .incorrect)
                    
                    currentWrongPair = (selectedItem, item)
                    showWrongAnswerView = true
                    isQuizInteractionDisabled = true
                }
                
                self.selectedItemId = nil
            } else {
                self.selectedItemId = id
                updateItemState(id, borderColor: .pressed)
            }
        }
    }
    
    private func updateItemState(_ id: UUID, borderColor: QuizButtonBorderColor, isDisabled: Bool = false) {
        if let index = displayedPhrases.firstIndex(where: { $0.id == id }) {
            displayedPhrases[index].borderColor = borderColor
            displayedPhrases[index].isDisabled = isDisabled
        } else if let index = displayedMeanings.firstIndex(where: { $0.id == id }) {
            displayedMeanings[index].borderColor = borderColor
            displayedMeanings[index].isDisabled = isDisabled
        }
    }
    
    func resetIncorrectSelection() {
        if let (item1, item2) = currentWrongPair {
            updateItemState(item1.id, borderColor: .normal)
            updateItemState(item2.id, borderColor: .normal)
        }
        currentWrongPair = nil
        showWrongAnswerView = false
        isQuizInteractionDisabled = false
    }
    
    private func checkQuizFinished() {
        let totalPairs = displayedPhrases.count
        isQuizFinished = correctPairsCount == totalPairs
        
        if isQuizFinished {
            saveData()  // Save quiz data when the quiz is completed
        }
    }

    
    func saveData() {
        let contextCount = getContext?.context.count ?? 0
        let setScore = Int((Double(correctPairsCount) / Double(numberOfAttempts)) * 100) // Calculate score based on correct pairs and attempts
        let getLastResult = VocabeeStorage.structData(VocabResult.self, forKey: .RESULT_DATA)
        var learnedVocab = VocabeeStorage.structArrayData(VocabList.self, forKey: .LEARNED_VOCAB)
        
        // Save quiz result
        if let lastResult = getLastResult {
            // Update with new results
            let updatedResult = VocabResult(vocabTotal: lastResult.vocabTotal + 1, contextTotal: lastResult.contextTotal + contextCount, score: setScore)
            VocabeeStorage.setStruct(updatedResult, forKey: .RESULT_DATA)
        } else {
            // Save the result for the first time
            let newResult = VocabResult(vocabTotal: 1, contextTotal: contextCount, score: setScore)
            VocabeeStorage.setStruct(newResult, forKey: .RESULT_DATA)
        }
        
        // Save learned vocab
        if let currentVocab = getContext {
            learnedVocab.append(currentVocab)
            VocabeeStorage.setStructArray(learnedVocab, forKey: .LEARNED_VOCAB)
        }
        
        // Debug print statements to verify the saving process
        print("CHECK SCORE: \(setScore)")
        print("CHECK LEARNED VOCAB: \(VocabeeStorage.structArrayData(VocabList.self, forKey: .LEARNED_VOCAB))")
        if let vocabResult = VocabeeStorage.structData(VocabResult.self, forKey: .RESULT_DATA) {
            print("CHECK VOCAB RESULT: Vocab Total: \(vocabResult.vocabTotal), Context Total: \(vocabResult.contextTotal), Score: \(vocabResult.score)")
        } else {
            print("CHECK VOCAB RESULT: No result found")
        }
    }
}
