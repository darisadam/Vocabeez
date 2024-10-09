//
//  GetReadyView.swift
//  Vocabee
//
//  Created by Sry Tambunan on 29/09/24.
//

import SwiftUI
import UserNotifications

struct GetReadyView: View {
    @Binding var currentPage: String
    @State private var selectedTime: String?
    @State private var progress: Double = 0.66

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Get Ready")
                    .font(.title)
                    .foregroundColor(Color("BiruTua"))

                ProgressBar(progressColor: Color("BiruTua"), backgroundColor: Color(UIColor.systemGray4), progress: progress)
                    .padding(.top, 5)
            }
            .padding(.horizontal, 15)
            .padding(.top, 80)

            HStack {
                Image("Bee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 20)
                
                Text("We’ll remind you to practice till it becomes a habit!")
                    .font(.system(size: 16, weight: .medium))
                    .padding()
                
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                HapticFeedback.medium.impact()
                currentPage = "BenefitView"
            }) {
                Text("Let’s Go")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Button"))
                    .cornerRadius(11)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 55)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            requestNotificationPermission()
        }
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
               
                print("Notification permission error: \(error.localizedDescription)")
            }
            print("Permission granted: \(granted)")
        }
    }
}

struct GetReadyView_Previews: PreviewProvider {
    static var previews: some View {
        GetReadyView(currentPage: .constant("GetReadyView"))
    }
}

