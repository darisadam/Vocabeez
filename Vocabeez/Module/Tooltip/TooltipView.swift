//
//  TooltipView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

struct TooltipView: View {
    @State private var currentTooltipIndex = 0
    let tooltipViewModel = TooltipViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(tooltipViewModel.tooltip[currentTooltipIndex].title)
                .font(.poppins(.medium, .title))
            
            Text(tooltipViewModel.tooltip[currentTooltipIndex].description)
                .font(.poppins(.regular, .headline))
            
            HStack {
                Text("\(tooltipViewModel.tooltip[currentTooltipIndex].id)")
                    .font(.poppins(.regular, .headline))
                
                Text("/\(tooltipViewModel.tooltip.count)")
                    .font(.poppins(.regular, .footnote))
                    .foregroundStyle(Color(hex: "979393"))
                    .padding(.leading, -5)
                
                Spacer()
                
                Button {
                    if currentTooltipIndex < tooltipViewModel.tooltip.count - 1 {
                        currentTooltipIndex += 1
                    }
                } label: {
                    Text("Next")
                        .font(.poppins(.regular, .headline))
                        .foregroundStyle(.black)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 15)
                        .background(Color(hex: "FACB73"))
                        .cornerRadius(11)
                        .shadow(color: Color(hex: "C39430"), radius: 0.1, x: 0, y: 4)
                }
                .disabled(currentTooltipIndex >= tooltipViewModel.tooltip.count - 1)
            }
        }
        .padding()
    }
}

#Preview {
    TooltipView()
}
