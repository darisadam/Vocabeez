//
//  QuizSummaryView.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI

struct QuizSummaryView: View {
    @State private var navigationPath = NavigationPath()
    @State private var showLoadingPage = false
    
    let quizVM = QuizViewModel()
    let getScore = VocabeeStorage.structData(VocabResult.self, forKey: .RESULT_DATA)?.score ?? 0
    let firstStatement = "Awesome job! You're doing great! Keep up the practice and explore even more vocab to sharpen your skills!"
    let secondStatement = "Nice work! You're getting the hang of it! Keep practicing to master vocab in even more contexts!"
    let thirdStatement = "Almost there! Keep practicing, and you’ll get even better at understanding vocab in various contexts!"
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("Quiz Summary")
                    .font(.poppins(.extraBold, size: 40))
                    .foregroundColor(Color(hex: "#525A67"))
                
                Image("Bee")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 226)
                    .rotationEffect(.degrees(-35))
                
                Text("Accuracy \(getScore)%")
                    .font(.poppins(.extraBold, size: 40))
                    .foregroundColor(Color(hex: "#525A67"))
                
                Text(getScore >= 80 ? firstStatement : (getScore > 50 ? secondStatement : thirdStatement))
                    .font(.poppins(.regular, size: 18))
                    .foregroundColor(Color(hex: "#525A67"))
                
                Spacer()
                
                VStack(spacing: 24) {
                    NavigationLink(destination: CardView(selectedCard: nil, selectedVocab: nil)) {
                        Text("Next Practice")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(Color("Button"))
                            .foregroundColor(.black)
                            .cornerRadius(11)
                            .onTapGesture {
                                HapticFeedback.medium.impact()
                            }
                    }
                    
                    Button {
                        HapticFeedback.medium.impact()
                        // Set quiz completion flag in UserDefaults
                        UserDefaults.standard.set(true, forKey: "HAS_COMPLETED_QUIZ")
                        UserDefaults.standard.synchronize()
                        
                        showLoadingPage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            navigationPath.append(NavigationDestination.dashboard)
                            showLoadingPage = false
                        }
                    } label: {
                        Text("Done")
                            .font(.poppins(.bold, size: 18))
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(Color(hex: "#3F679F"))
                            .cornerRadius(11)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color(hex: "3F679F")
                                .opacity(1), lineWidth: 5)
                            .padding(.horizontal, 0)
                    )
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .dashboard:
                    DashboardView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showLoadingPage)
                case .quiz, .card:
                    LoadingPage()
                }
            }
        }
        .overlay(
            Group {
                if showLoadingPage {
                    LoadingPage()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showLoadingPage)
                }
            }
        )
        .onDisappear {
            VocabeeStorage.set(value: nil, forKey: .RESULT_DATA)
        }
    }
}

#Preview {
    QuizSummaryView()
}

