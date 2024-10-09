//
//  CardTooltip.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 05/10/24.
//

import SwiftUI

struct CardTooltip: View {
    private let cardTooltip = ["tooltip5", "tooltip6"]
    
    @State private var tooltipID = 0
    
    var body: some View {
        if tooltipID < cardTooltip.count {
            GeometryReader { geometry in
                Image(cardTooltip[tooltipID])
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                    .onTapGesture {
                        HapticFeedback.medium.impact()
                        tooltipID += 1
                        if tooltipID == cardTooltip.count {
                            // Tooltip dismissed after last image
                            VocabeeStorage.set(value: true, forKey: .HAS_SEEN_CARD_TOOLTIP)
                        }
                    }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CardTooltip()
}
