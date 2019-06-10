import AVFoundation
import UIKit
import Speech

let rockSound = getSound(soundName: "Rocks.wav")

func getSound(soundName:String) -> AVAudioPlayer? {
    let rockPath = Bundle.main.path(forResource: soundName, ofType:nil)!
    let url = URL(fileURLWithPath: rockPath)
    var sound: AVAudioPlayer?
    do {
        sound = try AVAudioPlayer(contentsOf: url)
    } catch {
        print("Failed to find", soundName)
    }
    return sound
}

// GENERIC FUNCTION TO PLAY ANY SOUND
func playSOUND(sound: AVAudioPlayer?) {
    sound?.pause()
    sound?.play()
}

func playRocksFalling() {
    let deadlineSec = DispatchTime.now()
    
    DispatchQueue.main.asyncAfter(deadline: deadlineSec) {
        playSOUND(sound:rockSound)
    }
}
