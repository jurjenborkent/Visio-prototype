//
//  ViewController.swift
//  Spraak naar tekst
//
//  Created by Laurens Post, Jurjen Borkent, Niels Ettema en Thijs Govers
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var fadedView: UIView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var recordedMessage: UITextView!
    
    var speechData: [Speech]!
    
    lazy var speechRecognizer: SFSpeechRecognizer? = {
        if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "nl-NL")) {
            recognizer.delegate = self
            return recognizer
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: SFSpeechRecognizerDelegate {}

extension ViewController: UITableViewDelegate {}

extension ViewController: UITableViewDataSource {}






















