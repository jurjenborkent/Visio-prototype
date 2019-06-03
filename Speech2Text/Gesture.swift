//
//  Actions.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 28/05/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation
import UIKit
import Speech

enum CheckWhichGestures {
    case speech
    case tab
}

var speech : CheckWhichGestures = .speech
var tab : CheckWhichGestures = .tab
    var JumpSound: AVAudioPlayer?
    var recognitionTask: SFSpeechRecognitionTask?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

var audioEngine: AVAudioEngine = {
    let audioEngine = AVAudioEngine()
    return audioEngine
}()

var speechRecognizer: SFSpeechRecognizer? = {
    if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "nl-NL")) {
       // recognizer.delegate
        return recognizer
    }
    return nil
}()

func getGesture (gesture : CheckWhichGestures) {
    if gesture == .speech {
        func startRecording() {
            
            if let recognitionTask = recognitionTask {
                recognitionTask.cancel()
             //   recognitionTask = 0
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
                
                let c = Soundex()
                
                var isFinal = false
                if let result = result {
                    var sentence = result.bestTranscription.formattedString
                    // Only pick the first word from the speech
                    var recordedMessage = sentence.components(separatedBy: " ").last
                    let SoundexedWord = c.soundex(recordedMessage!)
                    isFinal = result.isFinal
                    print("Recordedmessage:", SoundexedWord)
                    print(result.bestTranscription.formattedString)
                    sentence = ""
                    print("Sentence:", sentence)
                    
                    if SoundexedWord == "J500" || SoundexedWord == "S165" || SoundexedWord == "J510" || SoundexedWord == "J400" || SoundexedWord == "Y000" || SoundexedWord == "J000" || SoundexedWord == "Y000" || SoundexedWord == "J520" || SoundexedWord == "D520" || SoundexedWord == "S360" || SoundexedWord == "P616" || SoundexedWord == "P600" || SoundexedWord == "N000" || SoundexedWord == "J000" || SoundexedWord == "R520" || SoundexedWord == "P600" || SoundexedWord == "P660" || SoundexedWord == "R000" || SoundexedWord == "P662" || SoundexedWord == "R200" || SoundexedWord == "Z520" || SoundexedWord == "V526" || SoundexedWord == "F650" || SoundexedWord == "D652"  || SoundexedWord == "S365" || SoundexedWord == "K652" ||  SoundexedWord == "R526" {
                        let path = Bundle.main.path(forResource: "jump.mp3", ofType:nil)!
                        let url = URL(fileURLWithPath: path)
                        do {
                            JumpSound = try AVAudioPlayer(contentsOf: url)
                            JumpSound?.play()
                            print("Sound working")
                            recordedMessage = ""
                            sentence = ""
                            print("Recordedmessage2:", recordedMessage!)
                        } catch {
                            print("Failed to play the sound")
                        }
                    } else {
                        recordedMessage = ""
                        sentence = ""
                        print("Recordedmessage3:", recordedMessage!)
                        print("Sentence2:", sentence)
                        //   print("String is empty")
                        isFinal = false
                    }
                    recordedMessage = ""
                    sentence = ""
                    print("Sentence3:", sentence)
                }
                
                if error != nil || isFinal {
                    audioEngine.stop()
                    audioEngine.inputNode.removeTap(onBus: 0)
                  //  recognitionRequest = nil
                    recognitionTask = nil
                   // recordButton.isEnabled = true
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
    if gesture == .tab {
        print("Use the tab function")
    }
}
