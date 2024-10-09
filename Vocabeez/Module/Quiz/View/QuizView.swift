//
//  QuizView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 28/09/24.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var quizVM = QuizViewModel()
    @StateObject private var returningUserChartVM = ReturningUserChartViewModel()
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToDashboard = false
    @State private var navigateToSummaryView = false
    @State private var showTutorial = false
    
    //MARK: - QUIZ MODIFIER
    
    var body: some View {
        NavigationView {
            ZStack {
                quizContent
                //WRONG ANSWER MODAL
                if quizVM.showWrongAnswerView {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {}
                    
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            WrongAnswer(wrongPair: quizVM.currentWrongPair) {
                                HapticFeedback.medium.impact()
                                quizVM.resetIncorrectSelection()
                            }
                            .frame(height: min(geometry.size.height * 0.3, 160))
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
                //QUIZ TUTORIAL OVERLAY
                if showTutorial {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {}
                    
                    GeometryReader { geometry in
                        QuizTutorial(isPresented: $showTutorial)
                            .frame(width: 340)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0), value: quizVM.showWrongAnswerView)
            .animation(.easeInOut(duration: 1.0).delay(0.5), value: showTutorial)
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
                title: Text("Leaving already?"),
                message: Text("You can do better! Just a few more questions to answer...."),
                primaryButton: .destructive(Text("Quit & Lose Progress")) {
                    HapticFeedback.medium.impact()
                    presentationMode.wrappedValue.dismiss() // This will pop back to the previous view
                },
                secondaryButton: .cancel(Text("Keep Trying")) {
                    HapticFeedback.medium.impact()
                }
            )
        }
        .background(
            NavigationLink(destination: DashboardView().navigationBarHidden(true), isActive: $navigateToDashboard) {
                EmptyView()
            })
        .onAppear {
                quizVM.generateNewQuiz()

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                showTutorial = true
            }
        }
    }
    
    //MARK: - QUIZ CONTENT
    
    private var quizContent: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "F9F6F4")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image("Bee")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 48)
                        .padding(.bottom, 20)
                    
                    Text("Match the context on the left\nwith the correct meaning on\nthe right.")
                        .font(.poppins(.regular, .subheadline))
                        .padding(.leading, 30)
                        .padding(.trailing, 60)
                        .padding(.vertical, 10)
                        .background(
                            RoundedCornerShape(corners: [.topRight, .bottomLeft, .bottomRight], radius: 12)
                                .fill(Color(hex: "#ECE3DA")))
                        .frame(height: 150)
                }
                .padding(.horizontal)
                .padding(.bottom, -25)
                
                HStack(alignment: .top, spacing: 31) {
                    VStack(spacing: 15) {
                        ForEach(quizVM.displayedPhrases) { item in
                            MatchButton(
                                title: item.text,
                                width: 183,
                                height: 99,
                                borderColor: item.borderColor,
                                isDisabled: item.isDisabled || quizVM.isQuizInteractionDisabled,
                                action: {
                                    HapticFeedback.medium.impact()
                                    quizVM.selectItem(item.id)
                                })
                        }
                    }
                    
                    VStack(spacing: 24) {
                        ForEach(quizVM.displayedMeanings) { item in
                            MatchButton(
                                title: item.text,
                                width: 146,
                                height: 90,
                                borderColor: item.borderColor,
                                isDisabled: item.isDisabled || quizVM.isQuizInteractionDisabled,
                                action: {
                                    HapticFeedback.medium.impact()
                                    quizVM.selectItem(item.id)
                                })
                        }
                    }
                    .padding(.top, 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                Button(action: {
                    if quizVM.isQuizFinished {
                        HapticFeedback.medium.impact()
                        UserDefaults.standard.set(true, forKey: "HAS_COMPLETED_QUIZ")
                        returningUserChartVM.incrementContextForQuiz(by: quizVM.correctPairsCount)
                        quizVM.saveData()
                        VocabeeStorage.setBool(true, forKey: .HAS_COMPLETED_QUIZ)
                        navigateToSummaryView = true
                    }
                }) {
                    Text("Done")
                        .font(.poppins(.semiBold, .headline))
                        .foregroundColor(quizVM.isQuizFinished ? Color(hex: "000000") : Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(quizVM.isQuizFinished ? Color("Button") : Color.gray.opacity(0.3))
                        .cornerRadius(11)
                        .padding(.horizontal, 20)
                }
                .disabled(!quizVM.isQuizFinished)
                
                Spacer()
            }
        }
        .background(
            NavigationLink(destination: QuizSummaryView().navigationBarHidden(true), isActive: $navigateToSummaryView) {
                LoadingPage()
            }
        )
    }
}

#Preview {
    QuizView()
}
