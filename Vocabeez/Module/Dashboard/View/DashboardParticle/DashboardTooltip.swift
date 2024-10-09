//
//  DashboardTooltip.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 05/10/24.
//

import SwiftUI

struct DashboardTooltip: View {
    private let dashboardTooltip = ["tooltip1", "tooltip2", "tooltip3", "tooltip4"]
    
    @State private var tooltipID = 0
    
    var body: some View {
        if tooltipID < dashboardTooltip.count {
            GeometryReader { geometry in
                Image(dashboardTooltip[tooltipID])
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                    .onTapGesture {
                        HapticFeedback.medium.impact()
                        tooltipID += 1
                        if tooltipID == dashboardTooltip.count {
                            // Tooltip dismissed after last image
                            VocabeeStorage.set(value: true, forKey: .HAS_SEEN_DASHBOARD_TOOLTIP)
                        }
                    }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    DashboardTooltip()
}
