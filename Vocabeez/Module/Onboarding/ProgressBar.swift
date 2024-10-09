//
//  ProgressBar.swift
//  Vocabee
//
//  Created by Sry Tambunan on 29/09/24.
//

import SwiftUI

struct ProgressBar: View {
    var progressColor: Color
    var backgroundColor: Color
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 8)
                    .foregroundColor(backgroundColor)
                Capsule()
                    .frame(width: geometry.size.width * CGFloat(progress), height: 8) // Use progress to determine width
                    .foregroundColor(progressColor)
            }
        }
        .frame(height: 8)
    }
}

