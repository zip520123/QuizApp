//
//  QuizTest.swift
//  QuizEngineTests
//
//  Created by zip520123 on 21/01/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        super.setUp()
        quiz = Quiz.start(questions: ["Q1","Q2"], delegate: delegate, correctAnswers:["Q1":"A1","Q2":"A2"])
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        
        delegate.answerCallback("Wrong")
        delegate.answerCallback("Wrong")
        
        XCTAssertEqual(delegate.handleResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        
        delegate.answerCallback("A1")
        delegate.answerCallback("Wrong")
        
        XCTAssertEqual(delegate.handleResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handleResult!.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
 
        var handleResult: Result<String, String>? = nil
        var answerCallback: (String) -> Void = {_ in}
        
        func answer(for: String, completion: @escaping (String) -> Void) {
            self.answerCallback = completion
        }
        
        func handle(result: Result<String, String>) {
            handleResult = result
        }
        
        
    }
}
