//
//  MainModel.swift
//  Vocabee
//
//  Created by Isaac Tambunan on 29/09/24.
//

import Foundation

struct VocabList: Codable, Identifiable {
    var id: Int? = 0
    let vocab: String
    let wordList: [WordList]?
    let context: [ContextData]
}

struct WordList: Codable {
    let word: String
    let definitions: String
    let examples: [String]?
}

struct ContextData: Codable {
    let situation: String
    let conversation: [ConversationData]
    let meaningOfVocab: [MeaningOfVocabData]
    let contextMatch: ContextMatchData
}

struct ConversationData: Codable {
    let person: String
}

struct MeaningOfVocabData: Codable {
    let name: String
    let isCorrect: Bool
}

struct ContextMatchData: Codable, Identifiable {
    let id: Int
    let context: String
    let mean: String
}

struct VocabResult: Codable {
    let vocabTotal: Int
    let contextTotal: Int
    let score: Int
}

struct CharacterData: Codable {
    let name: String
    let language: String
    let rate: Float
    let volume: Float
    let pitchMultiplier: Float
}
