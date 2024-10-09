//
//  CalendarView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                ForEach(viewModel.weekDates) { dayModel in
                    CalendarDayView(calendarModel: dayModel)
                }
            }
        }
        .onAppear {
            viewModel.resetHighlightedStatus()
        }
    }
}

#Preview {
    CalendarView()
}
