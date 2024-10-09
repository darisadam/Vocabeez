//
//  VocabListDetailView.swift
//  Vocabee
//
//  Created by Isaac Tambunan on 07/10/24.
//

import SwiftUI

struct VocabListDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var detailData: WordList?
    let items = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 25) {
                    Text("Here’s a summary of the meanings of '\(detailData?.word ?? "")'")
                        .font(.system(size: 14, weight: .regular))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Definitions")
                            .font(.system(size: 18, weight: .bold))
                        
                        Text(detailData?.definitions ?? "-")
                            .font(.system(size: 14, weight: .regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Examples in Different Situations")
                            .font(.system(size: 18, weight: .bold))
                        
                        if (detailData?.examples?.count)! > 0 {
                            ForEach(Array((detailData?.examples!.enumerated())!), id: \.offset) { index, item in
                                HStack {
                                    Text("\(String(index + 1)). ")
                                        .frame(maxHeight: .infinity, alignment: .topLeading)
                                        .font(.system(size: 14, weight: .regular))
                                    Text(item)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 14, weight: .regular))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            }
        }
        .navigationTitle("Charge")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    VocabListDetailView()
}
