//
//  LearningGoalsView.swift
//  Vocabee
//
//  Created by Sry Tambunan on 29/09/24.
//

import SwiftUI
import UserNotifications

struct LearningGoalsView: View {
    @Binding var currentPage: String
    @State private var selectedTime: String?
    @State private var progress: Double = 0.33

    var body: some View {
        NavigationView {
            VStack {

                VStack(spacing: 20) {
                    Text("Goals")
                        .font(.title)
                        .foregroundColor(Color("BiruTua"))

                    ProgressBar(progressColor: Color("BiruTua"), backgroundColor: Color(UIColor.systemGray4), progress: progress)
                        .padding(.top, 5)
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)


                HStack {
                    Image("Bee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 16)

                    Text("Let’s set up your learning routine journey!")
                        .font(.system(size: 16, weight: .medium))
                        .padding()

                    Spacer()
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 20)


                VStack(spacing: 16) {
                    ForEach(["5:00 AM", "8:00 AM", "1:00 PM", "4:00 PM", "9:00 PM"], id: \.self) { time in
                        GoalItem(time: time, description: descriptionForTime(time: time), selectedTime: $selectedTime)
                    }
                }
                .padding(.top, 20)

                Spacer()

                Button(action: {
                    HapticFeedback.medium.impact()
                    if let time = selectedTime {
                        scheduleNotification(for: time)
                        currentPage = "GetReadyView"
                    }
                }) {
                    Text("Let’s Go")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTime == nil ? Color.gray : Color("Button"))
                        .cornerRadius(11)
                }
                .disabled(selectedTime == nil)                .padding(.horizontal, 16)
                .padding(.bottom, 20)

            }
            .navigationBarHidden(true)
        }
    }

    private func descriptionForTime(time: String) -> String {
        switch time {
        case "5:00 AM": return "I’m an Early Morning Person"
        case "8:00 AM": return "I’m a Morning Go-Getter"
        case "1:00 PM": return "I Learn Best After Lunch"
        case "4:00 PM": return "I’m an Afternoon Achiever"
        case "9:00 PM": return "I’m a Night Owl"
        default: return ""
        }
    }

    // Function untuk schedule notifikasinya
    private func scheduleNotification(for time: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted && error == nil {
                let content = UNMutableNotificationContent()
                content.title = "Time to Learn!"
                content.body = "It's \(time), your scheduled learning time."
                content.sound = UNNotificationSound.default
                
                let dateComponents = getTimeComponents(for: time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }

    // Helper function to get time components
    private func getTimeComponents(for time: String) -> DateComponents {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let date = formatter.date(from: time) ?? Date()
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
}

struct GoalItem: View {
    var time: String
    var description: String
    @Binding var selectedTime: String?

    var body: some View {
        Button(action: {
            HapticFeedback.medium.impact()
            selectedTime = time
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(time)
                        .font(.headline)
                        .foregroundColor(selectedTime == time ? Color.blue : Color.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)  // Pastikan ada background agar tombol tidak kosong
            .cornerRadius(10)
            .shadow(radius: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedTime == time ? Color.blue : Color.clear, lineWidth: 2)
            )
            .contentShape(Rectangle()) // Memastikan seluruh area bisa di klik
        }
        .buttonStyle(PlainButtonStyle()) // Menghindari efek default button SwiftUI
        .frame(maxWidth: .infinity) // Memastikan tombol lebar penuh
        .padding(.horizontal, 16)
    }
}

struct LearningGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        LearningGoalsView(currentPage: .constant("LearningGoalsView"))
    }
}
