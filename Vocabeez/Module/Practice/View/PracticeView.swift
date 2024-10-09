//
//  PracticeView.swift
//  Vocabee
//
//  Created by Isaac Tambunan on 28/09/24.
//

import SwiftUI

struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var backToDashboard = false
    @State private var navigate = false
    @State private var showAlert = false
    
    @State public var vocabData: VocabList
    @State private var currentPractice: [SituationPractice] = []
    @State private var currentMeaningOfVocab: [MeaningOfVocabData] = []
    @State private var currentSituation = 0
    @State private var answerClicked = 0
    
    @State private var composing = false
    @State private var scalingFromTop = false
    
    @State private var visibleIndex = 0
    
    @StateObject private var returningUserChartVM = ReturningUserChartViewModel()
    
    let speech = SpeechSynthesizer()
    
    var body: some View {
        NavigationView {
            content
                .background(
                    NavigationLink(destination: QuizView(), isActive: $navigate) {
                        EmptyView()
                    }
                )
        }
        .navigationTitle("Practice Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(destination: DashboardView(), isActive: $backToDashboard) {
                EmptyView()
            }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    HapticFeedback.medium.impact()
                    showAlert = true
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Leaving already ?"),
                message: Text("You can do better ! Just a few more practices left int the lesson ...."),
                primaryButton: .destructive(Text("Quit & Lose Progress")) {
//                    presentationMode.wrappedValue.dismiss()
                    backToDashboard = true
                },
                secondaryButton: .cancel(Text("Keep Learning"))
            )
        }
    }
    
    private var content: some View {
        ZStack(alignment: .top) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 30) {
                        
                        ForEach(Array(currentPractice.enumerated()), id: \.element.chat) { idx, item in
                            if idx <= visibleIndex {
                                if (item.type == "female") {
                                    FemaleChat(item: item.chat)
                                        .id(item.chat)
                                } else if (item.type == "male") {
                                    MaleChat(item: item.chat)
                                        .id(item.chat)
                                } else if (item.type == "answer") {
                                    AnswerChat(item: item.chat)
                                        .id(item.chat)
                                } else if (item.type == "correctAnswer") {
                                    CorrectAnswerChat(item: item.chat)
                                        .id(item.chat)
                                } else if (item.type == "incorrectAnswer") {
                                    IncorrectAnswerChat(item: item.chat)
                                        .id(item.chat)
                                } else if (item.type == "next") {
                                    
                                } else {
                                    BeeChat(item: item.chat)
                                        .id(item.chat)
                                }
                            }
                        }
                            .onChange(of: currentPractice, { _, _ in
                                withAnimation {
                                    proxy.scrollTo(currentPractice.last?.chat, anchor: .bottom)
                                }
                            })
//                            .onAppear {
//                                withAnimation {
//                                    proxy.scrollTo(currentPractice.last?.chat, anchor: .bottom)
//                                }
//                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 110)
                }
//                .defaultScrollAnchor(.bottom)
                
                // MARK: -MEANING CONTEXT OPTION
                VStack(spacing: 10) {

                    ForEach(Array(currentMeaningOfVocab.enumerated()), id: \.element.name) { idx, item in
                        if currentMeaningOfVocab.count == 1 {
                            meanOfContextOption(item: item.name)
                                .padding(.vertical, 32)
                                .onTapGesture {
                                    HapticFeedback.medium.impact()
                                    if currentSituation >= (vocabData.context.count - 1) {
                                        // redirect to context match view
                                        returningUserChartVM.incrementContextForPractice()
                                        VocabeeStorage.setBool(true, forKey: .HAS_USED_PRACTICE_FEATURE)
                                        navigate = true
                                    } else {
                                        nextScenario()
                                    }
                                }
                        } else {
                            if (idx == 0) {
                                meanOfContextOption(item: item.name)
                                    .padding(.top, 32) // ONLY FIRST COMPONENT
                                    .onTapGesture {
                                        HapticFeedback.medium.impact()
                                        answerClicked += 1
                                        currentPractice.append(SituationPractice(type: "answer", situationName: "“Situation \(currentSituation + 1)”", chat: item.name))
                                        visibleIndex += 1
                                        
                                        CheckAnswer(isCorrect: item.isCorrect)
                                        
                                        if (answerClicked >= 2 || item.isCorrect) {
                                            currentMeaningOfVocab = [MeaningOfVocabData(name: "\(currentSituation >= 4 ? "Let's Have a Quiz!! 🙌" : "Let’s try a new scenario 🚀")", isCorrect: false)]
                                        }
                                        
                                        withAnimation {
                                            if (visibleIndex == (currentPractice.count - 1)) {
                                                proxy.scrollTo(currentPractice.last?.chat, anchor: .bottom)
                                            }
                                        }
                                    }
                            } else if (idx == (currentMeaningOfVocab.count - 1)) {
                                meanOfContextOption(item: item.name)
                                    .padding(.bottom, 32) // ONLY LAST COMPONENT
                                    .onTapGesture {
                                        HapticFeedback.medium.impact()
                                        answerClicked += 1
                                        currentPractice.append(SituationPractice(type: "answer", situationName: "“Situation \(currentSituation + 1)”", chat: item.name))
                                        visibleIndex += 1
                                        
                                        CheckAnswer(isCorrect: item.isCorrect)
                                        
                                        if (answerClicked >= 2 || item.isCorrect) {
                                            currentMeaningOfVocab = [MeaningOfVocabData(name: "\(currentSituation >= 4 ? "Let's Have a Quiz!! 🙌" : "Let’s try a new scenario 🚀")", isCorrect: false)]
                                        }
                                        
                                        withAnimation {
                                            if (visibleIndex == (currentPractice.count - 1)) {
                                                proxy.scrollTo(currentPractice.last?.chat, anchor: .bottom)
                                            }
                                        }
                                    }
                            } else {
                                meanOfContextOption(item: item.name)
                                    .onTapGesture {
                                        HapticFeedback.medium.impact()
                                        answerClicked += 1
                                        currentPractice.append(SituationPractice(type: "answer", situationName: "“Situation \(currentSituation + 1)”", chat: item.name))
                                        visibleIndex += 1
                                        
                                        CheckAnswer(isCorrect: item.isCorrect)
                                        
                                        if (answerClicked >= 2 || item.isCorrect) {
                                            currentMeaningOfVocab = [MeaningOfVocabData(name: "\(currentSituation >= 4 ? "Let's Have a Quiz!! 🙌" : "Let’s try a new scenario 🚀")", isCorrect: false)]
                                        }
                                        withAnimation {
                                            if (visibleIndex == (currentPractice.count - 1)) {
                                                proxy.scrollTo(currentPractice.last?.chat, anchor: .bottom)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(hex: "#FFFEFF"))
                        .shadow(color: .gray, radius: 3, x: 2, y: 0)
                )
                .padding(.horizontal, -24)
                .padding(.bottom, -32)
            }
            .background(Color(hex: "#F9F6F4"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Text("")
                VStack(alignment: .leading) {
                    Text("“Situation \(currentSituation + 1)”")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(hex: "#FFF"))
                        .padding(.horizontal, 18)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 73)
                .background(Color(hex: "#32406F"))
                .cornerRadius(6)
                .background(
                    RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 6)
                        .fill(Color(hex: "#E0BB46"))
                        .frame(height: 73)
                        .padding(.top, 6)
                )
                .padding(.horizontal, 24)
            }
            .background(.white.opacity(0.8))
            .frame(maxWidth: .infinity)
        }
        .onAppear{
            currentSituation = 0
            
            answerClicked = 0
            currentPractice = []
            currentMeaningOfVocab = []
            
            currentPractice.append(SituationPractice(type: "bee", situationName: "“Situation \(currentSituation + 1)”", chat: "Hey, let’s take a fun look at the conversation below!"))
            
            if (vocabData.context.count > 0) {
                let context = vocabData.context[0]
                let conversation = context.conversation

                for (idx, item) in conversation.enumerated() {
                    let type = (idx + 1) % 2 == 0 ? "female" : "male"
                    currentPractice.append(SituationPractice(type: type, situationName: context.situation, chat: item.person))
                }
                
                currentMeaningOfVocab = vocabData.context[0].meaningOfVocab.shuffled()
                
                currentPractice.append(SituationPractice(type: "bee", situationName: "“Situation \(currentSituation + 1)”", chat: "What does “\(vocabData.vocab)” mean in the conversation above?"))
            }
            
            loopWithDelay()
        }
    }
    
    func loopWithDelay() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if visibleIndex < currentPractice.count - 1 {
                visibleIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func nextScenario() {
        currentSituation += 1
        
        answerClicked = 0
        currentPractice = []
        currentMeaningOfVocab = []
        
        currentPractice.append(SituationPractice(type: "bee", situationName: "“Situation \(currentSituation + 1)”", chat: "Hey, let’s take a fun look at the conversation below!"))
        
        if (vocabData.context.count > 0) {
            let context = vocabData.context[currentSituation]
            let conversation = context.conversation

            for (idx, item) in conversation.enumerated() {
                let type = (idx + 1) % 2 == 0 ? "female" : "male"
                currentPractice.append(SituationPractice(type: type, situationName: context.situation, chat: item.person))
            }
            
            currentMeaningOfVocab = vocabData.context[currentSituation].meaningOfVocab.shuffled()
            
            currentPractice.append(SituationPractice(type: "bee", situationName: "“Situation \(currentSituation + 1)”", chat: "What does “\(vocabData.vocab)” mean in the conversation above?"))
        }
    }
    
    private func CheckAnswer(isCorrect: Bool) {
        if isCorrect {
            currentPractice.append(SituationPractice(type: "correctAnswer", situationName: "“Situation \(currentSituation + 1)”", chat: "In this context, “\(vocabData.vocab)” means the responsibility for managing or overseeing the project"))
        } else {
            currentPractice.append(SituationPractice(type: "incorrectAnswer", situationName: "“Situation \(currentSituation + 1)”", chat: "While ”\(vocabData.vocab)” can refer to a fee, this meaning does not apply here. The emphasis is on responsibility and leadership rather than a financial aspect. \nGive it another go!"))
        }
        loopWithDelay()
    }
    
    private func AnswerChat(item: String) -> some View {
        VStack(alignment: .trailing) {
            VStack {
                Text(item)
                    .frame(alignment: .trailing)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#181A20"))
                    .frame(height: 42)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedCornerShape(corners: [.topLeft, .bottomLeft, .bottomRight], radius: 12)
                            .fill(Color(hex: "#E6E7E9"))
                    )
                    .offset(y: scalingFromTop ? 0 : 0)
                    .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func CorrectAnswerChat(item: String) -> some View {
        HStack(alignment: .top) {
            Image("icon-bee")
                .resizable()
                .frame(width: 45, height: 48)
                .onTapGesture{
                }
            VStack(spacing: 10) {
                Text("Excellent")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: "#FFF"))
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#FFF"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(
                RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                    .fill(Color(hex: "#3F679F"))
            )
            .offset(y: scalingFromTop ? 0 : 0)
            .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func IncorrectAnswerChat(item: String) -> some View {
        HStack(alignment: .top) {
            Image("icon-bee")
                .resizable()
                .frame(width: 45, height: 48)
                .onTapGesture{
                }
            VStack(spacing: 10) {
                Text("Almost There, Revise")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: "#FFF"))
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#FFF"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(
                RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                    .fill(Color(hex: "#E7545B"))
            )
            .offset(y: scalingFromTop ? 0 : 0)
            .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func BeeChat(item: String) -> some View {
        HStack(alignment: .top) {
            Image("icon-bee")
                .resizable()
                .frame(width: 45, height: 48)
                .onTapGesture{
                }
            VStack {
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#181A20"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(
                RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                    .fill(Color(hex: "#ECE3DA"))
            )
            .offset(y: scalingFromTop ? 0 : 0)
            .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func MaleChat(item: String) -> some View {
        HStack(alignment: .top) {
            Image("Albert-icon")
                .resizable()
                .scaledToFit()
                .frame(height: 53)
                .onTapGesture{
                }
            
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
//                    .onAppear{
//                        speech.speak(item, as: .male)
//                    }
                    .onTapGesture{
                        speech.speak(item, as: .male)
                    }
                
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#181A20"))
                    .mask(Rectangle().offset(x: composing ? 0 : -330))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(
                RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                    .fill(.clear)
                    .stroke(Color(hex: "#79797B"), lineWidth: 1)
            )
            .offset(y: scalingFromTop ? 0 : 0)
            .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func FemaleChat(item: String) -> some View {
        HStack(alignment: .top) {
            Image("Bella-icon")
                .resizable()
                .scaledToFit()
                .frame(height: 53)
                .onTapGesture{
                }
            
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
//                    .onAppear{
//                        speech.speak(item, as: .female)
//                    }
                    .onTapGesture{
                        speech.speak(item, as: .female)
                    }
                
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color(hex: "#181A20"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(
                RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                    .fill(.clear)
                    .stroke(Color(hex: "#79797B"), lineWidth: 1)
            )
            .offset(y: scalingFromTop ? 0 : 0)
            .scaleEffect(scalingFromTop ? 1 : 0, anchor: scalingFromTop ? .trailing : .leading )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scalingFromTop = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
               composing = true
            }
        }
    }
    
    private func meanOfContextOption(item: String) -> some View {
        VStack(alignment: .leading) {
            Text(item)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color(hex: "#000"))
                .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .background(Color(hex: "#F4F5F7"))
        .cornerRadius(11)
        .background(
            RoundedCornerShape(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 11)
                .fill(Color(hex: "#d4d2d3"))
                .frame(height: 45)
                .padding(.top, 6)
        )
        .padding(.horizontal, 32)
    }
}

#Preview {
    var selectedVocab: VocabList? = nil
    
    let setData = VocabList(id: 1, vocab: "Office", wordList: [WordList(word: "In Charge", definitions: "To be responsible for something.", examples: ["She is in charge of organizing the event."])], context: [
        ContextData(situation: "Discussing the new office layout.", conversation: [ConversationData(person: "I agree! It feels more inviting.")], meaningOfVocab: [MeaningOfVocabData(name: "asdasdasd", isCorrect: false)], contextMatch: ContextMatchData(id: 12345, context: "The office is busy today.", mean: "The workplace has many people working."))
        
    ])
    
    PracticeView(vocabData: selectedVocab ?? VocabList(id: 0, vocab: "", wordList: [], context: []))
}
