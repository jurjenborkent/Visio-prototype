//
//  StartRecording.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 05/06/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

var recognitionTask: SFSpeechRecognitionTask?
var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

class recordingForIntro: ViewController {

func startRecordingIntro() {
    
    if let recognitionTask = recognitionTask {
        recognitionTask.cancel()
        self.recognitionTask = nil
    }
    
    // recordedMessage.text = ""
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
    }catch {
        print(error)
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    guard let recognitionRequest = recognitionRequest else {
        fatalError("Unable to create a speech audio buffer")
    }
    
    recognitionRequest.shouldReportPartialResults = true
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
        
        // Get the Soundex function
        let word = Soundex()
        // isFinal to false
        var isFinal = false
        if let result = result {
            var sentence = result.bestTranscription.formattedString
            // Only pick the last word from the speech
            var recordedMessage = sentence.components(separatedBy: " ").last
            let SoundexedWord = word.soundex(recordedMessage!)
            
            // Store the data
            let valueToSave = SoundexedWord
            UserDefaults.standard.set(valueToSave, forKey: "recordedMessage")
            
            isFinal = result.isFinal
            print(result.isFinal)
            print("Recordedmessage:", SoundexedWord)
            print(result.bestTranscription.formattedString)
            sentence = ""
            recordedMessage = ""
            sentence = ""
        }
        
        if error != nil || isFinal {
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest = nil
            self.recognitionTask = nil
            self.recordButton.self.isEnabled = true
        }
    })
    
    let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
    audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
        recognitionRequest.append(buffer)
    }
    
    audioEngine.prepare()
    do {
        try audioEngine.start()
    } catch {
        print(error)
    }
}
}
