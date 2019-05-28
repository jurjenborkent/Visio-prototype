//
//  RocksFalling.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 28/05/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import AVFoundation
import UIKit
import Speech

var BackgroundSound: AVAudioPlayer?
var RockSound: AVAudioPlayer?

func PlayRocksFalling() {
    
    let path = Bundle.main.path(forResource: "running.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
        BackgroundSound?.pause()
        BackgroundSound = try AVAudioPlayer(contentsOf: url)
        BackgroundSound?.play()
        print("Startup sound working!")
    } catch {
        print("Failed to play startup sound")
    }
    
    let rockFirstFallingDelay = 3.0 // Time To Delay
    let whenFirstFall = DispatchTime.now() + rockFirstFallingDelay
    
    DispatchQueue.main.asyncAfter(deadline: whenFirstFall) {
        let path = Bundle.main.path(forResource: "Rocks.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            RockSound?.pause()
            RockSound = try AVAudioPlayer(contentsOf: url)
            RockSound?.play()
            print("Rock sound working!")
        } catch {
            print("Failed to play rock sound")
        }
    }
    
    let rockSecondFallingDelay = 10.0 //Time To Delay
    let whenSecondFall = DispatchTime.now() + rockSecondFallingDelay
    
    DispatchQueue.main.asyncAfter(deadline: whenSecondFall) {
        let path = Bundle.main.path(forResource: "Rocks.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            RockSound?.pause()
            RockSound = try AVAudioPlayer(contentsOf: url)
            RockSound?.play()
            print("Rock sound working!")
        } catch {
            print("Failed to play rock sound")
        }
    }
    
    let rockThirdFallingDelay = 22.0 //Time To Delay
    let whenThirdFall = DispatchTime.now() + rockThirdFallingDelay
    
    DispatchQueue.main.asyncAfter(deadline: whenThirdFall) {
        let path = Bundle.main.path(forResource: "Rocks.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            RockSound?.pause()
            RockSound = try AVAudioPlayer(contentsOf: url)
            RockSound?.play()
            print("Rock sound working!")
        } catch {
            print("Failed to play rock sound")
        }
    }
    
    let rockFourthFallingDelay = 35.0 //Time To Delay
    let whenFourthFall = DispatchTime.now() + rockFourthFallingDelay
    
    DispatchQueue.main.asyncAfter(deadline: whenFourthFall) {
        let path = Bundle.main.path(forResource: "Rocks.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            RockSound?.pause()
            RockSound = try AVAudioPlayer(contentsOf: url)
            RockSound?.play()
            print("Rock sound working!")
        } catch {
            print("Failed to play rock sound")
        }
    }
    
    let endTheGameDelay = 40.0 //Time To Delay
    let whenToEndTheGame = DispatchTime.now() + endTheGameDelay
    
    DispatchQueue.main.asyncAfter(deadline: whenToEndTheGame) {
        let path = Bundle.main.path(forResource: "you-win.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            BackgroundSound?.pause()
            BackgroundSound = try AVAudioPlayer(contentsOf: url)
            BackgroundSound?.play()
            print("End game sound working!")
        } catch {
            print("Failed to play end game sound")
        }
    }
}
