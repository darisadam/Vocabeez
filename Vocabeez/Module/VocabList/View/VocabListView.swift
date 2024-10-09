//
//  VocabListView.swift
//  Vocabee
//
//  Created by Isaac Tambunan on 07/10/24.
//

import SwiftUI

struct VocabListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
//    @SceneStorage("drop_down_zindex") private var index = 1000.0
    
//    @State private var vocabLists = VocabeeStorage.structArrayData(VocabList.self, forKey: .LEARNED_VOCAB)
    @State private var vocabLists: [VocabList] = loadJSON("generalVocab.json")
    @State var showDropdown = false
    @State var vocabIdx = 0
    @State private var textHeight: CGFloat = .zero
    @State private var wrapperHeight: CGFloat = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                ScrollView {
                    ForEach(Array(vocabLists.enumerated()), id: \.element.vocab) { idx, item in
                        VStack {
                            HStack {
                                Text(item.vocab)
                                    .font(.system(size: 18, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image("icon-show-dropdown")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .offset(x: -7)
                                    .padding(.leading, 16)
                                    .rotationEffect(.degrees((showDropdown && vocabIdx == idx) ? 90 : 0))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 59)
                            .padding(.horizontal, 21)
                            .background(Color(hex: "#ECE3DA"))
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(11)
                        .onTapGesture {
                            vocabIdx = idx
                            withAnimation(.snappy) {
                                showDropdown.toggle()
                            }
                        }
                        .zIndex(99)
                        
                        SubVocabListView(showDropdown: showDropdown, idx: idx, vocabIdx: vocabIdx, subData: item.wordList ?? [], textHeight: $textHeight)
                            .padding(.bottom, (showDropdown && vocabIdx == idx) ? (textHeight + 40) : 0)
                    }
                }
            }
        }
        .navigationTitle("List of Vocabularies")
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
        .padding(15)
    }
}

struct SubVocabListView: View {
    var showDropdown: Bool
    var idx = 0
    var vocabIdx = 0
    var subData: [WordList] = []
    @Binding var textHeight: CGFloat
    @State var setTextHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .leading, spacing: 10) {
                if (subData.count) > 0 {
                    
                    ForEach(Array(subData.enumerated()), id: \.offset) { index, item in
                        
                        NavigationLink(destination: VocabListDetailView(detailData: item)) {
                            Text(item.word)
                                .font(.system(size: 18, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .frame(height: 40)
                                .foregroundColor(.black)
                                .background(GeometryReader { geometry in
                                    Color.clear
                                        .preference(key: TextHeightPreferenceKey.self, value: geometry.size.height)
                                })
                                .onPreferenceChange(TextHeightPreferenceKey.self) { height in
                                    self.setTextHeight += (height + 10)
                                    self.textHeight = (setTextHeight)
                                }
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .frame(height: (showDropdown && vocabIdx == idx) ? textHeight : 0)
            .padding(.horizontal, 21)
            .padding(.vertical, (showDropdown && vocabIdx == idx) ? 21 : 0)
            .background(Color(hex: "#ECE3DA"))
            .cornerRadius(11)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: .infinity)
        }
    }
}

struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
        print("check size", nextValue())
    }
}

#Preview {
    VocabListView()
}
