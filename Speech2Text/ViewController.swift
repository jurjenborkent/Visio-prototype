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
    
    
    var isListining = false
    var listiningStart = 0
    var jumpSucces = false
    
    // counter variables
    var lives = 3
    
    var coinsCollected = 0
    var rockDropped = 0
    var rockDropInterval = 10
    
    // Setting
    var timer = Timer()
    var seconds = 0
    var player = AVAudioPlayer()
    
    
    // function that was uses on tab command.
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
    
    // function to run the timer.
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.gameLoop)), userInfo: nil, repeats: true)
        
   
    // function for increasing the seconds en doing stuff within it. GAME LOOP
    }
    @objc func gameLoop() {
        seconds += 1     //This will increment (count up) the seconds.
        print(seconds)
        // Execute after 5 seconds every 10 secs, let rocks fall
        if (seconds > 5 && ((rockDropped == 0) || (rockDropped + self.rockDropInterval) == seconds)) {
            print("Stones dropping!")
            // Let a rock fall down
            getActions(actions: rocksFalling)
            self.rockDropped = seconds
            isListining = true
            listiningStart = seconds
            jumpSucces = false
        }
        
        if (isListining == true && (listiningStart + 4) == seconds) {
            isListining = false
            if (!jumpSucces) {
                jumpFailed()
                lives -= 1
                print("levens: ", lives)
                liveLabel.text = String(lives)
                
            } else {
                coinsCollected += 1
                coinLabel.text = String(coinsCollected)
                UserDefaults.standard.set(coinsCollected, forKey: "highScore")
                highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highScore"))
            }
        }
        
        if (lives == 0) {
            print("STOPPEN")
//            if (UserDefaults.standard.integer(forKey: "highScore") > coinsCollected)
            UserDefaults.standard.set(coinsCollected, forKey: "highScore")
            
            exit(0);
        }
//        if (self.coinsCollected > 1) {
//           self.rockDropInterval -= 3
//        }
       
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

    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
  
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(coinsCollected, forKey: "highScore")
        liveLabel.text = String(lives)
        coinLabel.text = String(coinsCollected)
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highScore"))
        runTimer()
        gameLoop()
        // request auth
//        self.requestAuth()
        startRecording()
        // tableview delegations
        
        // hide recording views

        
//        getActions(actions: run)
////        while (true) {
////            getActions(aßctions: rocksFalling)
////        }
//
//        getGesture(gesture: speech) // Check gesture
//       // startIntro() // Start intro for the game
//      //  recording().recordIntro() // Recording for the intro
        getActions(actions: run) // Start running action
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    func requestAuth() {
//        SFSpeechRecognizer.requestAuthorization { (authStatus) in
//            DispatchQueue.main.async {
//                switch authStatus {
//                case .authorized:
//                    self.recordButton.isEnabled = true
//                case .denied, .notDetermined, .restricted:
//                    self.recordButton.isEnabled = false
//                }
//            }
//        }
//    }
    
//
    func stopRecording() {
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
            
            if (self.isListining) {
                
//                print("aan het luisteren")
            
                // Get the Soundex function
                let word = Soundex()
                var isFinal = false
                if let result = result {
                    var sentence = result.bestTranscription.formattedString
                    // Only pick the last word from the speech
                    var recordedMessage = sentence.components(separatedBy: " ").last
                    let SoundexWord = word.soundex(recordedMessage!)
                    
                    isFinal = result.isFinal
                    print(result.bestTranscription.formattedString)
                    sentence = ""
                    print("Sentence:", sentence)
                    
                    // Store the data
                    let valueToSave = SoundexWord
                    UserDefaults.standard.set(valueToSave, forKey: "recordedMessage")
                    
                    // Check if word is equal to the Soundex code
                    let elements = ["I500", "J500","S165", "J510", "J400", "Y000", "J000", "J520", "D520", "S360", "P616", "P600", "N000", "R520", "P600", "P660", "R000", "P662", "R200", "Z520", "V526", "F650", "D652", "S365", "K652", "R526", "H520", "S155", "T520", "J516", "S600", "S160", "S162",]
                    
                    var currentIndex = 0
                    for element in elements
                    {
                        if element == SoundexWord {
//                            print("Found \(element) for index \(currentIndex)")
                            
//                            if UserDefaults.standard.string(forKey: "recordedMessage") != nil {
//                                elements.append(valueToSave)
//                                print(elements)
//                            }
                            // Play jump sound if word is equal to Soundex code
                            
                            jumpCommand()
                            print("Gesprongen!")
                            recordedMessage = ""
                            sentence = ""
                            self.jumpSucces = true
                            break
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
                }
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








