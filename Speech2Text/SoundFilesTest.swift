//
//  SoundFilesTest.swift
//  Speech2Text
//
//  Created by XCodeClub on 2019-06-27.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation
import Speech
import XCTest

class SoundFileLoaderTests: XCTestCase {
    func testSoundFile(soundName:String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!
        let queue = DispatchQueue(label: "SoundFilesTests")
        
        path(named: ["Jump", "Rocks", "Mario-coin-sound"], on: queue)
        
        queue.sync {}
        let SoundFileNames = path.map { $0.name }
        XCTAssertEqual(SoundFileNames, ["Jump", "Rocks", "Mario-coin-sound"])
    }
}
