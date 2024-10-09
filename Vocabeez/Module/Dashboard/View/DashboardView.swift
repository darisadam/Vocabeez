//
//  MainView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 23/09/24.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DashboardViewModel()
    @State private var navigateToQuizView = false
    @State private var navigateToPracticeView = false
    @State private var navigateToVocabListView = false
    @State private var showTooltip = false
    
    let quizVM = QuizViewModel()
    
    var currentMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F9F6F4")
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // MARK: - Header
                    HStack {
                        HStack {
                            Text("Hello")
                                .font(.poppins(.semiBold, .largeTitle))
                                .foregroundStyle(Color(hex: "525A67"))
                            Text("There")
                                .font(.poppins(.semiBold, .largeTitle))
                                .foregroundStyle(Color(hex: "E5744E"))
                            Text("!")
                                .font(.poppins(.semiBold, .largeTitle))
                                .foregroundStyle(Color(hex: "525A67"))
                        }
                        Spacer()
                        Button {
                            HapticFeedback.medium.impact()
                            navigateToVocabListView = true
                        } label: {
                            Image(systemName: "book.fill")
                                .font(.title)
                                .foregroundStyle(Color(hex: "#515966"))
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Text(currentMonthYear)
                            .font(.poppins(.semiBold, .headline))
                            .foregroundStyle(Color(hex: "515966"))
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, -5)
                    
                    // MARK: - Calendar
                    CalendarView()
                    
                    // MARK: - Chart
                    ZStack {
                        RoundedRectangle(cornerRadius: 11)
                            .foregroundStyle(Color(hex: "F5F6F8"))
                            .shadow(color: .gray, radius: 5, x:  0, y: 6)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 30)
                        ChartView()
                    }
                    
                    // MARK: - Buttons
                    VStack(spacing: 20) {
                        Button(action: {
                            HapticFeedback.medium.impact()
                            navigateToPracticeView = true
                        }) {
                            DashboardButton(
                                title: "Today's Vocab",
                                backgroundColor: Color(hex: "FACB73"),
                                titleColor: Color(hex: "181A20"),
                                shadowColor: Color(hex: "C39430"),
                                shadowY: 5)
                        }
                        
                        Button(action: {
                            HapticFeedback.medium.impact()
                            if viewModel.shouldShowFirstTimeAlert() {
                                viewModel.showFirstTimeAlert = true
                            } else {
//                                quizVM.generateNewQuiz()
                                navigateToQuizView = true
                            }
                        }) {
                            DashboardButton(
                                title: "Let's Have a Quiz!!",
                                backgroundColor: Color(hex: "F8F7F3"),
                                titleColor: Color(hex: "3F679F"),
                                shadowColor: Color(hex: "3F679F"),
                                shadowY: 0)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "3F679F")
                                    .opacity(1), lineWidth: 5)
                                .padding(.horizontal, 16))
                    }
                }
                
                //MARK: - Dashboard Tooltip
                
                if viewModel.showFirstTimeAlert {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { }
                    
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            FirstTimeAlert(dismissAction: viewModel.dismissFirstTimeAlert)
                                .frame(height: min(geometry.size.height * 1, 450))
                        }
                        .padding(.bottom, -50)
                    }
                    .transition(.move(edge: .bottom))
                }
                
                if showTooltip {
                    DashboardTooltip()
                        .transition(.opacity)
                        .onTapGesture {}
                }
            }
            // Disable navigation bar
            .navigationBarHidden(true)  // This hides the navigation bar
            .onAppear {
                quizVM.generateNewQuiz()
                if VocabeeStorage.getBool(forKey: .HAS_SEEN_DASHBOARD_TOOLTIP) == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showTooltip = true
                        }
                    }
                }
                
                // Check if the user has used the practice feature
                if VocabeeStorage.getBool(forKey: .HAS_USED_PRACTICE_FEATURE) == true {
                    viewModel.showFirstTimeAlert = false
                }
            }
            .navigationDestination(isPresented: $navigateToPracticeView) {
                CardView(selectedCard: nil, selectedVocab: nil)
            }
            .navigationDestination(isPresented: $navigateToQuizView) {
                QuizView()
            }
            .navigationDestination(isPresented: $navigateToVocabListView) {
                VocabListView()
            }
        }
    }
}


#Preview {
    DashboardView()
}
