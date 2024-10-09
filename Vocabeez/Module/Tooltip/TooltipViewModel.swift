//
//  TooltipViewModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import Foundation

struct TooltipViewModel {
    let tooltip: [TooltipModel] = [
        TooltipModel(id: 1, title: "Explore vocab!",
                     description: "You can explore various vocab in different situations."),
        TooltipModel(id: 2, title: "Quiz",
                     description: "Have fun testing your understanding with a quiz on the vocab you've learned!"),
        TooltipModel(id: 3, title: "Streak",
                     description: "Make it exciting to practice daily with streaks-your progress will be a joy to see!"),
        TooltipModel(id: 4, title: "Learned Vocab",
                     description: "Take a look at all the vocab you've mastered!"),
        TooltipModel(id: 5, title: "Suffle Card",
                     description: "Choose the vocab you want to learn by shuffling the cards."),
        TooltipModel(id: 6, title: "Option selections",
                     description: "You can pick the right meaning according to the context of the dialogue."),
    ]
    
}
