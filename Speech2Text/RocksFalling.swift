import AVFoundation
import UIKit
import Speech

let rockSound = getSound(soundName: "Rocks.wav")
let jumpSound = getSound(soundName: "jump.mp3")

func getSound(soundName:String) -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: soundName, ofType:nil)!
    let url = URL(fileURLWithPath: path)
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

func jumpCommand() {
    DispatchQueue.main.async() {
        playSOUND(sound:jumpSound)
    }

 
    
}
