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
        XCTAssertEqual(0,  BasiceScore.score(for:[], comparingTo: []))
    }
    
    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(0,  BasiceScore.score(for:["wrong"], comparingTo:["correct"]))
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        XCTAssertEqual(1, BasiceScore.score(for:["correct"], comparingTo:["correct"]))
    }
    
    private class BasiceScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            if answers.isEmpty {return 0}
            return answers == correctAnswers ? 1 : 0
        }
    }
}
