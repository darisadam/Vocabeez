//
//  VocabeeStorage.swift
//  Vocabee
//
//  Created by Isaac Tambunan on 26/09/24.
//

import Foundation

struct VocabeeStorage {
    static func set(value: Any?, forKey key: MyPreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getString(forKey key: MyPreferenceKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getDate(forKey key: MyPreferenceKey) -> Date? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Date
    }
    
    static func getArray(forKey key: MyPreferenceKey) -> [Any]? {
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
    
    static func getInt(forKey key: MyPreferenceKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func getBool(forKey key: MyPreferenceKey) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func setStruct<T: Codable>(_ value: T?, forKey key: MyPreferenceKey) {
        let data = try? JSONEncoder().encode(value)
        set(value: data, forKey: key)
    }
    
    static func setStructArray<T: Codable>(_ value: [T], forKey key: MyPreferenceKey) {
        let data = value.map { try? JSONEncoder().encode($0) }
        set(value: data, forKey: key)
    }
    
    static func structData<T>(_ type: T.Type, forKey key: MyPreferenceKey) -> T? where T : Decodable {
        guard let encodedData = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    static func structArrayData<T>(_ type: T.Type, forKey key: MyPreferenceKey) -> [T] where T : Decodable {
        guard let encodedData = UserDefaults.standard.array(forKey: key.rawValue) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    static func setBool(_ value: Bool, forKey key: MyPreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func setQuizCompletion(_ completed: Bool) {
        setBool(completed, forKey: .HAS_COMPLETED_QUIZ)
    }
    
    static func hasCompletedQuiz() -> Bool {
        return getBool(forKey: .HAS_COMPLETED_QUIZ)!
    }
    
    static func updateLearnedVocabData(vocabCount: Int, contextCount: Int, score: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(vocabCount, forKey: MyPreferenceKey.LEARNED_VOCAB_COUNT.rawValue)
        userDefaults.set(contextCount, forKey: MyPreferenceKey.LEARNED_CONTEXT_COUNT.rawValue)
        
        let result = VocabResult(vocabTotal: vocabCount, contextTotal: contextCount, score: score)
        if let encodedData = try? JSONEncoder().encode(result) {
            userDefaults.set(encodedData, forKey: MyPreferenceKey.RESULT_DATA.rawValue)
        }
        
        userDefaults.synchronize()
    }
    
    static func removeReference(){
        UserDefaults.standard.removeObject(forKey: "SELECTED_VOCAB")
        UserDefaults.standard.removeObject(forKey: "RESULT_DATA")
        UserDefaults.standard.removeObject(forKey: "LAST_QUIZ_SCORE")
        UserDefaults.standard.removeObject(forKey: "HAS_COMPLETED_QUIZ")
        UserDefaults.standard.removeObject(forKey: "LEARNED_VOCAB")
    }
}

enum MyPreferenceKey: String {
    case SELECTED_VOCAB
    case RESULT_DATA
    case LAST_QUIZ_SCORE
    case HAS_COMPLETED_QUIZ
    case LEARNED_VOCAB_COUNT
    case LEARNED_CONTEXT_COUNT
    case CURRENT_STREAK
    case LEARNED_VOCAB
    case HAS_SEEN_DASHBOARD_TOOLTIP
    case HAS_SEEN_CARD_TOOLTIP
    case HAS_USED_PRACTICE_FEATURE
}
