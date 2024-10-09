//
//  AudioPlayer.swift
//  Vocabee
//
//  Created by Sry Tambunan on 04/10/24.
//

import AVFoundation

class AudioPlayer {
    static let shared = AudioPlayer()  // Singleton instance to use this class globally
    var audioPlayer: AVAudioPlayer?

    // Initializes the audio session for background playback if needed
    init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session to playback mode, allowing audio to play even in the background if necessary
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }

    // Function to play a sound file from the app's bundle
    func playSound(named soundName: String, repeatCount: Int = 2) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Could not find sound file \(soundName).mp3 in the app bundle.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = repeatCount  // Set the number of loops (play 3 times = 2 repeats)
            audioPlayer?.play()
            print("Playing sound: \(soundName).mp3, will repeat \(repeatCount) times.")
        } catch {
            print("Could not play sound: \(error.localizedDescription)")
        }
    }
}
