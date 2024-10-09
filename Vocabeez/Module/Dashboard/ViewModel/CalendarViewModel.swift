//
//  CalendarViewModel.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var weekDates: [CalendarModel] = []
    @Published var streak: Int = 0 //Daily Streak Counter
    
    init() {
        updateWeekDates()
        loadStreak()
    }
    
    func updateWeekDates() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let weekStart = calendar.date(byAdding: .day, value: 1 - weekday, to: today)!
        
        weekDates = (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!
            let dayString = String(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1].prefix(1))
            let isHighlighted = VocabeeStorage.getBool(forKey: .HAS_COMPLETED_QUIZ) ?? false
            return CalendarModel(
                day: dayString,
                date: date,
                isHighlighted: isHighlighted,
                isToday: calendar.isDate(date, inSameDayAs: today)
            )
        }
    }
    
    func setHighlighted(for date: Date) {
        VocabeeStorage.set(value: true, forKey: .HAS_COMPLETED_QUIZ)
        updateWeekDates()
        updateStreak()
    }
    
    func resetHighlightedStatus() {
        let today = Date()
        let calendar = Calendar.current
        weekDates.forEach { model in
            if !calendar.isDate(model.date, inSameDayAs: today) {
                VocabeeStorage.set(value: false, forKey: .HAS_COMPLETED_QUIZ)
            }
        }
        updateWeekDates()
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let today = Date()
        var currentStreak = 0
        
        for day in (0...365).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { continue }
            let isHighlighted = VocabeeStorage.getBool(forKey: .HAS_COMPLETED_QUIZ) ?? false
            
            if isHighlighted {
                currentStreak += 1
            } else {
                break
            }
        }
        
        streak = currentStreak
        saveStreak()
    }
    
    private func saveStreak() {
        VocabeeStorage.set(value: streak, forKey: .CURRENT_STREAK)
    }
    
    private func loadStreak() {
        streak = VocabeeStorage.getInt(forKey: .CURRENT_STREAK)
    }
}
