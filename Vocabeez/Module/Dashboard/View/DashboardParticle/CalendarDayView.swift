//
//  CalendarDayView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import SwiftUI

struct CalendarDayView: View {
    let calendarModel: CalendarModel
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text(calendarModel.day)
                .font(.poppins(.semiBold, .title3))
                .foregroundStyle(calendarModel.isToday ? Color(hex: "515966") : Color(hex: "999999"))
            
            ZStack {
                Circle()
                    .fill(calendarModel.isHighlighted ? Color(hex: "E5744E") : Color(hex: "F9F6F4"))
                Text("\(Calendar.current.component(.day, from: calendarModel.date))")
                    .font(.poppins(.bold, .title3))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(calendarModel.isToday ? Color(hex: "515966") : Color(hex: "999999"))
            }
        }
        .frame(width: 40, height: 73)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(calendarModel.isToday ? Color(hex: "515966") : Color(hex: "999999"), lineWidth: 2)
        )
    }
}

#Preview {
    CalendarDayView(calendarModel: CalendarModel(
        day: "S",
        date: Date(),
        isHighlighted: true,
        isToday: true))
}
