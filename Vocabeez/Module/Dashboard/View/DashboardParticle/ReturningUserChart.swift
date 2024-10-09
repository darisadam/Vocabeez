//
//  ReturningUserChart.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 03/10/24.
//

import SwiftUI

struct ReturningUserChart: View {
    @StateObject private var viewModel = ReturningUserChartViewModel()
    
    var body: some View {
        ZStack {
            Image("beeHive")
            VStack {
                Text("Learned vocab!")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .padding(.top, 30)
                Text("\(String(describing: viewModel.dataResult?.vocabTotal ?? 0))")
                    .font(.poppins(.bold, size: 130))
                    .foregroundStyle(Color(hex: "525A67"))
                    .padding(.top, -40)
                    .padding(.bottom, -30)
                Text(viewModel.makeAttributedString())
                    .font(.poppins(.regular, .subheadline))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    ReturningUserChart()
}
