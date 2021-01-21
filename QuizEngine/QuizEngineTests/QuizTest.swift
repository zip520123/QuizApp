//
//  QuizTest.swift
//  QuizEngineTests
//
//  Created by zip520123 on 21/01/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

final class Quiz {
    private let flow: Any
    private init(flow: Any) {
        self.flow = flow
    }
    
    static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions:[Question], delegate: Delegate, correctAnswers:[Question: Answer]) -> Quiz where Question == Delegate.Question, Answer == Delegate.Answer {
        let flow = Flow(questions: questions, delegate: delegate) { scoring($0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}
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
    
    private class DelegateSpy: Router, QuizDelegate {
 
        var handleResult: Result<String, String>? = nil
        var answerCallback: (String) -> Void = {_ in}
        func routeTo(question: String, answerCallback: @escaping (String) -> Void){
            
            handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result: Result<String,String>) {
            handle(result: result)
        }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handleResult = result
        }
        
        
    }
}
