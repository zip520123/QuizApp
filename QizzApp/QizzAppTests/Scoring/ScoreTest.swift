//
//  ScoreTest.swift
//  QuizEngineTests_iOS_Test
//
//  Created by zip520123 on 03/02/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import XCTest
@testable import QizzApp
class ScoreTest: XCTestCase {
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(0,  BasiceScore.score(for:[String](), comparingTo: [String]()))
    }
    
    func test_oneNoMatchingAnswer_scoresZero() {
        XCTAssertEqual(0,  BasiceScore.score(for:["not a match"], comparingTo:["correct"]))
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        XCTAssertEqual(1, BasiceScore.score(for:["correct"], comparingTo:["correct"]))
    }
    
    func test_oneMatchingOneNoMatchingAnswer_scoresOne() {
        let score = BasiceScore.score(
            for:["an answer","not a match"],
            comparingTo:["an answer","another answer"])
        
        XCTAssertEqual(1, score)
    }
    
    func test_twoMatchingAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["an answer","another answer"],
            comparingTo:["an answer","another answer"])
        
        XCTAssertEqual(2, score)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["an answer","another answer", "an extra answer"],
            comparingTo:["an answer","another answer"])
        
        XCTAssertEqual(2, score)
    }
    
    func test_withTooManyCorrectAnswers_oneMatchingAnswers_scoreOne() {
        let score = BasiceScore.score(
            for:["not matching","another answer"],
            comparingTo:["an answer","another answer", "an extra answer"])
        
        XCTAssertEqual(1, score)
    }
    

}
