//
//  DashboardButton.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 27/09/24.
//

import SwiftUI

struct DashboardButton: View {
    let title: String
    let backgroundColor: Color
    let titleColor: Color
    let shadowColor: Color
    let shadowY: Int
    
    var body: some View {
        Text(title)
            .font(.poppins(.bold, .title2))
            .foregroundColor(titleColor)
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: 0.1, x:  0, y: CGFloat(shadowY)))
            .padding(.horizontal)
        
    }
}

#Preview {
    DashboardButton(
        title: "Test Button",
        backgroundColor: Color(hex: "FACB73"),
        titleColor: Color(hex: "181A20"),
        shadowColor: Color(hex: "C39430"),
        shadowY: 5)
}
