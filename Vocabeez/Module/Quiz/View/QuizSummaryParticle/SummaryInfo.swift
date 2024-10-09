//
//  SummaryInfo.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

struct SummaryInfo: View {
    var body: some View {
        HStack {
            VStack {
                Text("Total")
                    .font(.poppins(.semiBold, .headline))
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("10")
                }
            }
            .padding()

            VStack {
                Text("Correct")
                    .font(.poppins(.semiBold, .headline))
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("08")
                }
            }
            .padding()

            VStack {
                Text("Wrong")
                    .font(.poppins(.semiBold, .headline))
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("02")
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    SummaryInfo()
}
