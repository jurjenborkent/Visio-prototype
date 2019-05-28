//
//  Actions.swift
//  Speech2Text
//
//  Created by Post, L. (Laurens) on 28/05/2019.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation
import UIKit

enum CheckWhichActions {
    case nothing
    case jump
    case rocksFalling
}

var nothing : CheckWhichActions = .nothing
var jump : CheckWhichActions = .jump
var rocksFalling : CheckWhichActions = .rocksFalling

getActions (actions : CheckWhichActions) {
    switch actions {
    case .nothing:
        print("Do nothing")
    case .jump:
        print("Jump")
    case .rocksFalling:
        print("Rocks falling")
    default:
        print("Run")
    }
}



