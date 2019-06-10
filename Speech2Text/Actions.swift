//
//  Actions.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 28/05/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import AVFoundation
import UIKit
import Speech

enum CheckWhichActions {
    case run
    case failed
    case jump
    case rocksFalling
}

var backgroundSound: AVAudioPlayer?
var run : CheckWhichActions = .run
var failed : CheckWhichActions = .failed
var jump : CheckWhichActions = .jump
var rocksFalling : CheckWhichActions = .rocksFalling

func getActions (actions : CheckWhichActions) {
    switch actions {
    case .run:
        let startRunningDelay = 1.0 // Time To Delay
        let startRunning = DispatchTime.now() + startRunningDelay
        
        DispatchQueue.main.asyncAfter(deadline: startRunning) {
        let path = Bundle.main.path(forResource: "running.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundSound?.pause()
            backgroundSound = try AVAudioPlayer(contentsOf: url)
            backgroundSound?.play()
            print("Start running sound!")
        } catch {
            print("Failed to play run sound")
        }
        }
    case .failed:
        let path = Bundle.main.path(forResource: "you-win.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundSound?.pause()
            backgroundSound = try AVAudioPlayer(contentsOf: url)
            backgroundSound?.play()
            print("Start game over sound!")
        } catch {
            print("Failed to play game over sound")
        }
    case .jump:
        print("Jump")
    case .rocksFalling:
        playRocksFalling()
    }
}



