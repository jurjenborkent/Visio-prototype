//
//  Actions.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 28/05/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation
import UIKit

enum CheckWhichGestures {
    case speech
    case tab
}

var speech : CheckWhichGestures = .speech
var tab : CheckWhichGestures = .tab

func getGesture (gesture : CheckWhichGestures) {
    if gesture == .speech {
        print("Use the speech function")
    }
    if gesture == .tab {
        print("Use the tab function")
    }
}
