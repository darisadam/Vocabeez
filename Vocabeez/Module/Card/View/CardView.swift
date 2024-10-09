//
//      ContentView.swift
//      ShuffleCard
//    
//      Created by Sry Tambunan on 29/09/24.
    
    
    
import SwiftUI
import CoreHaptics

struct CardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @State private var cards = ["Card1", "Card2", "Card3", "Card4", "Card5", "Card6", "Card7"] // Image names in assets
    @State private var shuffledCards = ["Card1", "Card2", "Card3", "Card4", "Card5", "Card6", "Card7", "Card1", "Card2", "Card7", "Card1", "Card2", "Card2", "Card1", "Card2", "Card3", "Card4", "Card5", "Card5", "Card5"]
    @State var selectedCard: String? = nil
    @State var selectedVocab: VocabList? = nil
    @State private var isShuffling = false
    @State private var rotationAngle: Double = 0
    @State private var cardScales = [CGFloat](repeating: 1.0, count: 20)
    @State private var cardOpacities = [Double](repeating: 1.0, count: 20)
    @State private var centralCardScale: CGFloat = 0.0
    @State private var centralCardOpacity: Double = 0.0
    @State private var vocabOpacity: Double = 0.0
    @State private var glitterOpacity: Double = 0.0
    @State private var shuffleStartTime: Date?
    @State private var timer: Timer?
    @State private var vocabLists: [VocabList] = loadJSON("generalVocab.json")
    @State private var hapticEngine: CHHapticEngine?
    @State private var navigateToPractice = false
    @State private var selectedCardColor: Color = .white
    @State private var showAlert = false
    @State private var backToDashboard = false
    @State private var showTooltip = false
    let isSelectedVocab = VocabeeStorage.structData(VocabList.self, forKey: .SELECTED_VOCAB)

    let radius: CGFloat = 800
    let cardSize: CGFloat = 214
    let shuffleDuration: TimeInterval = 3

    var body: some View {
        NavigationView {
            ZStack {
                Color(Color("Background"))
                    .ignoresSafeArea()
                
                VStack {
                    if selectedCard == nil {
                        Text("Let's make it fun!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .transition(.opacity.combined(with: .scale))
                            .foregroundColor(.black)
                            .padding(.bottom, 300)
                            .padding(.top, -10)
                    } else {
                        Text("")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .padding(.top, 50)
                            .padding(.bottom, 50)
                            .foregroundColor(.black)
                            .transition(.opacity.combined(with: .scale))
                    }

                    ZStack {
                        ForEach(0..<(shuffledCards.count), id: \.self) { index in
                            let angle = Double(index) * (360.0 / Double(shuffledCards.count)) + rotationAngle
                            let zIndex = cos(angle * .pi / 180)

                            Image(shuffledCards[index]) // Display image from asset
                                .resizable()
                                .frame(width: 214, height: 321)
                                .scaleEffect(cardScales[index])
                                .opacity(cardOpacities[index])
                                .offset(
                                    x: -radius * cos(angle * .pi / 180),
                                    y: radius * sin(angle * .pi / 180)
                                )
                                .zIndex(zIndex)
                                .offset(x: 0, y: 720)
                        }

                        if let selectedCard = selectedCard {
                            ZStack {
                                Image(selectedCard) // Display the selected card image from assets
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 500, height: 500)
                                    .scaleEffect(centralCardScale)
                                    .opacity(centralCardOpacity)
                                    .padding(.top, -40)
                                    .padding(.bottom, 80)
                                    .rotation3DEffect(.degrees(centralCardScale * 360), axis: (x: 100, y: 300, z: 200))

                                if let selectedVocab = selectedVocab {
                                    VStack {
                                        Text(selectedVocab.vocab)
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 2)
                                            .opacity(vocabOpacity)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 0)

                    if selectedCard == nil {
                        // Full clickable button with padding and background
                        Button(action: {
                            HapticFeedback.medium.impact()
                            AudioPlayer.shared.playSound(named: "shuffle") // Play shuffle.mp3 sound
                            startShuffleAnimation() // Start card shuffle
                        }) {
                            Text("Shuffle Cards")
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(Color("Button"))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, -50)
                        .padding(.top, 200)
                    }
                }
                
                //Tooltip View
                if showTooltip {
                    CardTooltip()
                        .transition(.opacity)
                        .onTapGesture {}
                }
                
                // NavigationLink for moving to PracticeView
                NavigationLink(
                    destination: PracticeView(vocabData: selectedVocab ?? VocabList(id: 0, vocab: "", wordList: [], context: [])),
                    isActive: $navigateToPractice
                ) {
                    EmptyView()
                }
            }
            .onAppear {
                prepareHaptics()
            }
            .onAppear { //Tooltip
                if VocabeeStorage.getBool(forKey: .HAS_SEEN_CARD_TOOLTIP) == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showTooltip = true
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    HapticFeedback.medium.impact()
                    if isSelectedVocab == nil {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        backToDashboard = true
                    }
                    
                    /// SET SELECTED DATA NIL
                    VocabeeStorage.set(value: nil, forKey: .SELECTED_VOCAB)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }
        }
        .background(
            NavigationLink(destination: DashboardView().navigationBarHidden(true), isActive: $backToDashboard) {
                EmptyView()
            }
        )
    }

    func startShuffleAnimation() {
        isShuffling = true
        AudioPlayer.shared.playSound(named: "shuffle") // Play the shuffle sound
        shuffleStartTime = Date()
        var rotationSpeed = 5.0

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { tmr in
            guard let startTime = shuffleStartTime else { return }
            let elapsedTime = Date().timeIntervalSince(startTime)

            if elapsedTime >= shuffleDuration {
                tmr.invalidate()
                pauseAndSelectCard()
                return
            }

            if elapsedTime < 2 {
                rotationSpeed = min(rotationSpeed * 1.05, 15.0)
            } else if elapsedTime > shuffleDuration - 3 {
                rotationSpeed = max(rotationSpeed * 0.1, 2.0)
            }

            rotationAngle += rotationSpeed
            if elapsedTime.truncatingRemainder(dividingBy: 0.5) == 0 {
                playShuffleHaptic()
            }
        }
    }

    func pauseAndSelectCard() {
        withAnimation(.easeOut(duration: 0.001)) {
            rotationAngle = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // 1 second delay
            stopRotationAndSelectCard()
        }
    }

    func stopRotationAndSelectCard() {
        withAnimation(.easeOut(duration: 0.7)) {
            // Randomly select a card from the assets (Card1, Card2, ..., Card7)
            selectedCard = cards.randomElement()
            selectedVocab = vocabLists.randomElement()
            
            /// SAVE SELECTED DATA
            VocabeeStorage.setStruct(selectedVocab.self, forKey: .SELECTED_VOCAB)

            cardOpacities = [Double](repeating: 0, count: 20)

            // Set a random color for the selected card (if needed for background or additional design)
            selectedCardColor = randomColor()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 8)) {
                centralCardScale = 1.0
                centralCardOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeIn(duration: 0.5)) {
                    vocabOpacity = 5.0
                    glitterOpacity = 1.0
                }
                isShuffling = false
                playHaptic()
                // 2-second delay after the card is displayed before navigating to PracticeView
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToPractice = true
                }
            }
        }
    }

    func randomColor() -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .yellow, .purple, .pink]
        return colors.randomElement() ?? .white
    }

    // Prepare the haptic engine
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }

    // Play haptic feedback
    func playHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    // Play haptic feedback during shuffle
    func playShuffleHaptic() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play shuffle haptic pattern: \(error.localizedDescription).")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
