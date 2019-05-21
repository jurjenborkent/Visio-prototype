//
//  ViewController.swift
//  Spraak naar tekst
//
//  Created by Laurens Post, Jurjen Borkent, Niels Ettema en Thijs Govers
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var fadedView: UIView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var recordedMessage: UITextView!
    
    var speechData: [Speech]!
    var BackgroundSound: AVAudioPlayer?
    var JumpSound: AVAudioPlayer?
    var RockSound: AVAudioPlayer?
    
    lazy var speechRecognizer: SFSpeechRecognizer? = {
        if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "nl-NL")) {
            recognizer.delegate = self
            return recognizer
        }
        return nil
    }()
    
    lazy var audioEngine: AVAudioEngine = {
        let audioEngine = AVAudioEngine()
        return audioEngine
    }()
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // request auth
        self.requestAuth()
        
        // init data
        speechData = []
        
        // tableview delegations
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // hide recording views
        self.recordingView.isHidden = true
        self.fadedView.isHidden = true
        
        let path = Bundle.main.path(forResource: "running.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            self.BackgroundSound?.pause()
            self.BackgroundSound = try AVAudioPlayer(contentsOf: url)
            self.BackgroundSound?.play()
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
                self.RockSound?.pause()
                self.RockSound = try AVAudioPlayer(contentsOf: url)
                self.RockSound?.play()
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
                self.RockSound?.pause()
                self.RockSound = try AVAudioPlayer(contentsOf: url)
                self.RockSound?.play()
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
                self.RockSound?.pause()
                self.RockSound = try AVAudioPlayer(contentsOf: url)
                self.RockSound?.play()
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
                self.RockSound?.pause()
                self.RockSound = try AVAudioPlayer(contentsOf: url)
                self.RockSound?.play()
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
                self.BackgroundSound?.pause()
                self.BackgroundSound = try AVAudioPlayer(contentsOf: url)
                self.BackgroundSound?.play()
                print("End game sound working!")
            } catch {
                print("Failed to play end game sound")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func requestAuth() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied, .notDetermined, .restricted:
                    self.recordButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func didTapRecordButton(sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            self.startRecording()
            self.recordingView.isHidden = false
            self.fadedView.alpha = 0.0
            self.fadedView.isHidden = false
            UIView.animate(withDuration: 1.0) {
                self.fadedView.alpha = 1.0
            }
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            UIView.animate(withDuration: 0.5, animations: {
                self.fadedView.alpha = 0.0
            }) { (finished) in
                self.fadedView.isHidden = true
                self.recordingView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    func startRecording() {
        
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        self.recordedMessage.text = ""
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        }catch {
            print(error)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = self.recognitionRequest else {
            fatalError("Unable to create a speech audio buffer")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if let result = result {
                var sentence = result.bestTranscription.formattedString
                // Only pick the first word from the speech
                self.recordedMessage.text = sentence.components(separatedBy: " ").last
                isFinal = result.isFinal
                print("Recordedmessage:", self.recordedMessage.text)
                print(result.bestTranscription.formattedString)
                sentence = ""
                print("Sentence:", sentence)
                
                if self.recordedMessage.text  == "Spring" || self.recordedMessage.text == "Jump"
                    || self.recordedMessage.text == "Jill" || self.recordedMessage.text == "Jules" || self.recordedMessage.text == "Jim" || self.recordedMessage.text == "Junk" {
                    
                    let path = Bundle.main.path(forResource: "jump.mp3", ofType:nil)!
                    let url = URL(fileURLWithPath: path)
                    do {
                        self.JumpSound = try AVAudioPlayer(contentsOf: url)
                        self.JumpSound?.play()
                        print("Sound working")
                        self.recordedMessage.text = ""
                        sentence = ""
                        print("Recordedmessage2:", self.recordedMessage.text)
                        self.audioEngine.stop()
                    } catch {
                        print("Failed to play the sound")
                    }
                } else {
                    self.recordedMessage.text = ""
                    sentence = ""
                    self.audioEngine.stop()
                    print("Recordedmessage3:", self.recordedMessage.text)
                    print("Sentence2:", sentence)
                    //   print("String is empty")
                    isFinal = false
                }
                self.recordedMessage.text = ""
                sentence = ""
                print("Sentence3:", sentence)
                if sentence.components(separatedBy: " ").filter({ !$0.isEmpty}).count == 0 {
                    self.audioEngine.prepare()
                    do {
                        try self.audioEngine.start()
                        print("Audio engine started")
                    } catch {
                        print(error)
                    }
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
    }
}

extension ViewController: SFSpeechRecognizerDelegate {}
extension ViewController: UITableViewDelegate {}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speechData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        return cell
    }
}








