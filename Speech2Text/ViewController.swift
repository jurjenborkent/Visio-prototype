//
//  ViewController.swift
//  Spraak naar tekst
//
//  Created by Laurens Post
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
    
    var run : CheckWhichActions = .run
    var failed : CheckWhichActions = .failed
    var speech : CheckWhichGestures = .speech
    var JumpSound: AVAudioPlayer?
    var recognitionTask: SFSpeechRecognitionTask?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    // Setting
    var timer = Timer()
    var seconds = 60
    var player = AVAudioPlayer()
    
    func jump(_ sender: Any) {
        print("jump!") // testing button pressed tag
        
        let path = Bundle.main.path(forResource: "jumpSound", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
        } catch {
            print ("error playing sound!")
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        print(seconds)
        
        if seconds == 15 {
            print("jump")
        }
        
        if seconds == 50 {
            print("jump!") // testing button presse
        }
        
        if seconds == 45 {
            print("jump!") // testing button presse
        }
    }
    
   
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

    override func viewDidLoad() {
        super.viewDidLoad()
        runTimer()
        updateTimer()
        // request auth
        self.requestAuth()
        
        // tableview delegations
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // hide recording views
        self.recordingView.isHidden = true
        self.fadedView.isHidden = true
    
        getGesture(gesture: speech) // Check gesture
       // startIntro() // Start intro for the game
      //  recording().recordIntro() // Recording for the intro
        getActions(actions: run) // Start running action
        getActions(actions: rocksFalling) // Start rocks falling
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
            startRecording() // Start recording when button is pushed
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
            var isFinal = false
            if let result = result {
                var sentence = result.bestTranscription.formattedString
                // Only pick the last word from the speech
                var recordedMessage = sentence.components(separatedBy: " ").last
                let SoundexWord = word.soundex(recordedMessage!)
                
                isFinal = result.isFinal
                print("Recordedmessage:", SoundexWord)
                print(result.bestTranscription.formattedString)
                sentence = ""
                print("Sentence:", sentence)
                
                // Store the data
                let valueToSave = SoundexWord
                UserDefaults.standard.set(valueToSave, forKey: "recordedMessage")
                
                // Check if word is equal to the Soundex code
                var elements = ["J500","S165", "J510", "J400", "Y000", "J000", "J520", "D520", "S360", "P616", "P600", "N000", "R520", "P600", "P660", "R000", "P662", "R200", "Z520", "V526", "F650", "D652", "S365", "K652", "R526", "H520", "S155", "T520", "J516", "S600", "S160", "S162"]
                
                var currentIndex = 0
                for element in elements
                {
                    if element == SoundexWord {
                        print("Found \(element) for index \(currentIndex)")
                        
                        if UserDefaults.standard.string(forKey: "recordedMessage") != nil {
                            elements.append(valueToSave)
                            print(elements)
                        }
                        
                        let path = Bundle.main.path(forResource: "jump.mp3", ofType:nil)!
                        let url = URL(fileURLWithPath: path)
                        // Play jump sound if word is equal to Soundex code
                        do {
                            self.JumpSound = try AVAudioPlayer(contentsOf: url)
                            self.JumpSound?.play()
                            print("Sound working")
                            recordedMessage = ""
                            sentence = ""
                        } catch {
                            print("Failed to play the sound")
                        }
                    } else {
                        recordedMessage = ""
                        sentence = ""
                        isFinal = false
                       // getActions(actions: self.failed) // Stop the game
                    }
                        currentIndex += 1
                }
                recordedMessage = ""
                sentence = ""
                print("Sentence3:", sentence)
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

extension ViewController: SFSpeechRecognizerDelegate {}
extension ViewController: UITableViewDelegate {}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
}








