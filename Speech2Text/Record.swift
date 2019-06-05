//
//  Record.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 05/06/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class recording: recordingForIntro {
    
func recordIntro() {
    let recordDelay = 5.0 // Time To Delay
    let recording = DispatchTime.now() + recordDelay
    
    DispatchQueue.main.asyncAfter(deadline: recording) {
        
        do {
            self.startRecordingIntro()
            print("Started Recording")
            
            let recordStopDelay = 10.0 // Time To Delay
            let stopRecording = DispatchTime.now() + recordStopDelay
            DispatchQueue.main.asyncAfter(deadline: stopRecording) {
                if self.audioEngine.isRunning {
                    self.audioEngine.stop()
                    print("Stopped Recording")
                }
            }
        } catch {
            print("Failed to start recording")
        }
    }
}
}
