import AVFoundation
import UIKit
import Speech

let rockSound = getSound(soundName: "Rocks.wav")
let runSound = getSound(soundName: "Jump.mp3")

func getSound(soundName:String) -> AVAudioPlayer? {
    let Path = Bundle.main.path(forResource: soundName, ofType:nil)!
    let url = URL(fileURLWithPath: Path)
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
    DispatchQueue.main.async() {
        playSOUND(sound:rockSound)
    }
}

func playRunningSound() {
    DispatchQueue.main.async() {
        playSOUND(sound:runSound)
    }
}
