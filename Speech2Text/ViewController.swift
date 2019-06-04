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
        
        // init data
        //speechData = []
        
        // tableview delegations
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // hide recording views
        self.recordingView.isHidden = true
        self.fadedView.isHidden = true
    
        getGesture(gesture: speech)
        getActions(actions: run)
        startIntro()
        getActions(actions: rocksFalling)
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
            startRecording()
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
        
        recordedMessage.text = ""
        
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
                        self.JumpSound = try AVAudioPlayer(contentsOf: url)
                        self.JumpSound?.play()
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
                    isFinal = false
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








