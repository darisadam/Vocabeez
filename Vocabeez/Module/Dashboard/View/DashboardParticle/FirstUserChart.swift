//
//  FirstUserChart.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 03/10/24.
//

import SwiftUI

struct FirstUserChart: View {
    var body: some View {
        ZStack {
            Image("beeHive")
            VStack {
                Image("Bee")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80)
                    .rotationEffect(.degrees(35))
                    .padding(.bottom, 20)
                Text("Excited to see your progress!")
                    .font(.poppins(.bold, .title2))
                    .multilineTextAlignment(.center)
                Text("your vocab count here after trying different\ncontexts. Let’s start learning together!")
                    .font(.poppins(.regular, .subheadline))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    FirstUserChart()
}
