//
//  SpeechSynthesizer.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 29/09/24.
//

import AVFoundation

//enum SpeechCharacter: String, CaseIterable {
//    case albert, bella, naomi, angie, isaac, stormi
//    
//    var name: String {
//        switch self {
//        case .albert: return "Albert"
//        case .bella: return "Bella"
//        case .naomi: return "Naomi"
//        case .angie: return "Angie"
//        case .isaac: return "Isaac"
//        case .stormi: return "Stormi"
//        }
//    }
//    
//    var gender: String {
//        switch self {
//        case .albert, .isaac: return "Male"
//        case .bella, .naomi, .angie, .stormi: return "Female"
//        }
//    }
//    
//    var imageName: String {
//        return "\(name)-icon"
//    }
//    
//    var language: String {
//        switch self {
//        case .albert: return "en-IN"
//        case .bella: return "en-US"
//        case .naomi: return "en-AU"
//        case .angie: return "en-CA"
//        case .isaac: return "en-GB"
//        case .stormi: return "en-ZA"
//        }
//    }
//    
//    var rate: Float { 0.5 }
//    var volume: Float { 1.0 }
//    
//    var pitchMultiplier: Float {
//        switch self {
//        case .albert, .naomi, .isaac: return 1.5
//        case .bella, .angie: return 1.6
//        case .stormi: return 1.2
//        }
//    }
//}
//
//struct SpeechSynthesizer {
//    private var synthesizer = AVSpeechSynthesizer()
//    
//    func speak(_ conversation: String, as character: SpeechCharacter) {
//        let utterance = AVSpeechUtterance(string: conversation)
//        utterance.rate = character.rate
//        utterance.volume = character.volume
//        utterance.pitchMultiplier = character.pitchMultiplier
//        utterance.voice = AVSpeechSynthesisVoice(language: character.language)
//        synthesizer.speak(utterance)
//    }
//}




enum gender {
    case male
    case female
}

struct SpeechSynthesizer {
    let femaleCharacter = [
        CharacterData(name: "Bella", language: "en-US", rate: 0.5, volume: 1.0, pitchMultiplier: 1.6),
        CharacterData(name: "Naomi", language: "en-AU", rate: 0.5, volume: 1.0, pitchMultiplier: 1.5),
        CharacterData(name: "Angie", language: "en-CA", rate: 0.5, volume: 1.0, pitchMultiplier: 1.6),
        CharacterData(name: "Stormi", language: "en-ZA", rate: 0.5, volume: 1.0, pitchMultiplier: 1.2)
    ]
    let maleCharacter = [
        CharacterData(name: "Albert", language: "en-IN", rate: 0.5, volume: 1.0, pitchMultiplier: 1.5),
        CharacterData(name: "Isaac", language: "en-GB", rate: 0.5, volume: 1.0, pitchMultiplier: 1.5)
    ]
    private var synthesizer = AVSpeechSynthesizer()
    func speak(_ conversation: String, as gender: gender) {
        let utterance = AVSpeechUtterance(string: conversation)

        if gender == .male {
            let character = maleCharacter.randomElement()
            
            utterance.rate = character!.rate
            utterance.volume = character!.volume
            utterance.pitchMultiplier = character!.pitchMultiplier
            utterance.voice = AVSpeechSynthesisVoice(language: character!.language)
        } else {
            let character = femaleCharacter.randomElement()
            
            utterance.rate = character!.rate
            utterance.volume = character!.volume
            utterance.pitchMultiplier = character!.pitchMultiplier
            utterance.voice = AVSpeechSynthesisVoice(language: character!.language)
        }
        
        synthesizer.speak(utterance)
    }
}


//speak("asdasdasd", as: .male)
