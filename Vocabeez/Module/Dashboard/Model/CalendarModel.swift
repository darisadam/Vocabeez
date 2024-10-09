//
//  CalendarModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import SwiftUI

struct CalendarModel: Identifiable {
    let id = UUID()
    let day: String
    let date: Date
    var isHighlighted: Bool
    var isToday: Bool
}
