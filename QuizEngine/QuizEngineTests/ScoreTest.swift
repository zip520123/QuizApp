//
//  ScoreTest.swift
//  QuizEngineTests_iOS_Test
//
//  Created by zip520123 on 03/02/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import XCTest
class ScoreTest: XCTestCase {
    func test_noAnswers_scoresZero() {
        
        XCTAssertEqual(0,  BasiceScore.score([]))
    }
    
    private class BasiceScore {
        static func score(_ something: Any) -> Int {
            return 0
        }
    }
}
