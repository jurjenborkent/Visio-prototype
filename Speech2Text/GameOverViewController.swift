//
//  GameOverViewController.swift
//  Speech2Text
//
//  Created by Jurjen on 28/06/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScoreLabel.text = String(UserDefaults.standard.integer(forKey: "highScore"))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startOverButton(_ sender: Any) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        present(homeView, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
