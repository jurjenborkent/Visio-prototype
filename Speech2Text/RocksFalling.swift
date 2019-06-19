import AVFoundation
import UIKit
import Speech

let rockSound = getSound(soundName: "Rocks.wav")
let jumpSound = getSound(soundName: "jump.mp3")
let jumpFailedSound = getSound(soundName: "you-win.mp3")

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
func playSound(sound: AVAudioPlayer?) {
    sound?.pause()
    sound?.play()
}

func playRocksFalling() {
    DispatchQueue.main.async() {
        playSound(sound:rockSound)
    }
}

func jumpCommand() {
    DispatchQueue.main.async() {
        playSound(sound:jumpSound)
    }
}

func jumpFailed() {
    DispatchQueue.main.async() {
        playSound(sound:jumpFailedSound)
    }
}

    

