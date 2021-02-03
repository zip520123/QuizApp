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
    
    func test_oneCorrectOneWrongAnswer_scoresOne() {
        let score = BasiceScore.score(
            for:["correct 1","wrong"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(1, score)
    }
    
    func test_twoCorrectAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["correct 1","correct 2"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(2, score)
    }
    
    func test_withUnequalSizedData_twoCorrectAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["correct 1","correct 2", "an extra answer"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(2, score)
    }
    
    private class BasiceScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            var score = 0
            for (index,answer) in answers.enumerated() {
                if index >= correctAnswers.endIndex { return score }
                score += answer == correctAnswers[index] ? 1 : 0
            }
            return score
        }
    }
}
