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
        XCTAssertEqual(0,  BasiceScore.score(for:[], comparingTo: []))
    }
    
    func test_oneNoMatchingAnswer_scoresZero() {
        XCTAssertEqual(0,  BasiceScore.score(for:["not a match"], comparingTo:["correct"]))
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        XCTAssertEqual(1, BasiceScore.score(for:["correct"], comparingTo:["correct"]))
    }
    
    func test_oneMatchingOneNoMatchingAnswer_scoresOne() {
        let score = BasiceScore.score(
            for:["correct 1","not a match"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(1, score)
    }
    
    func test_twoMatchingAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["correct 1","correct 2"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(2, score)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoreTwo() {
        let score = BasiceScore.score(
            for:["correct 1","correct 2", "an extra answer"],
            comparingTo:["correct 1","correct 2"])
        
        XCTAssertEqual(2, score)
    }
    
    func test_withTooManyCorrectAnswers_oneMatchingAnswers_scoreOne() {
        let score = BasiceScore.score(
            for:["not matching","correct 2"],
            comparingTo:["correct 1","correct 2", "an extra answer"])
        
        XCTAssertEqual(1, score)
    }
    

}
