//
//  UserDefaultsTest.swift
//  Speech2Text
//
//  Created by XCodeClub on 2019-06-27.
//  Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation

import XCTest

extension UserDefaults {
    private static var index = 0
    static func createCleanForTest(label: StaticString = #file) -> UserDefaults {
        index += 1
        let suiteName = "UnitTest-UserDefaults-\(label)-\(index)"
        UserDefaults().removePersistentDomain(forName: suiteName)
        return UserDefaults(suiteName: suiteName)!
    }
}

class UserDefaultsTest: XCTestCase {
    
    func testOne() {
        let userDefaults = UserDefaults.createCleanForTest()
        XCTAssertFalse(userDefaults.bool(forKey: "foo"))
        userDefaults.set(true, forKey: "foo")
        XCTAssertTrue(userDefaults.bool(forKey: "foo"))
    }
    
    func testTwo() {
        let userDefaults = UserDefaults.createCleanForTest()
        XCTAssertFalse(userDefaults.bool(forKey: "foo"))
        userDefaults.set(true, forKey: "foo")
        XCTAssertTrue(userDefaults.bool(forKey: "foo"))
    }
}
