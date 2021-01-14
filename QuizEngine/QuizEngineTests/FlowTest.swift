//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by zip520123 on 08/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine
class FlowTest: XCTestCase {
    private let delegate = RouterSpy()
    func test_start_withNoQuestions_doseNotRouteToQuestion(){
        makeSUT(questions: []).start()
        XCTAssert(delegate.routedQuestions.isEmpty)
    }
    
    
    func test_start_withOneQuestions_routesToCorrectQuestion(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion_2(){
        
        makeSUT(questions:["Q2"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion(){
        
        makeSUT(questions:["Q1","Q2"]).start()
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_twice_withTwoQuestions_routesToFirstQuestionTwice(){
        let sut = makeSUT(questions:["Q1","Q2"])
        
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.routedQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstAndSecendQuestion_withThreeQuestions_routesToSecondAndThirdQuestion(){
        let sut = makeSUT(questions:["Q1","Q2", "Q3"])
        
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1","Q2","Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesnotRouteToAntherQuestion(){
        let sut = makeSUT(questions:["Q1"])
        
        sut.start()
        delegate.answerCallback("A1")
        
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_routeToResult(){
        makeSUT(questions:[]).start()
        
        XCTAssertEqual(delegate.routedResult!.answers, [:])
    }
    
    func test_start_withOneQuestion_doesNotRouteToResult(){
        makeSUT(questions:["Q1"]).start()
        
        XCTAssertNil(delegate.routedResult)
    }
    
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssert(delegate.routedResult!.answers == ["Q1":"A1", "Q2":"A2"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesRoutesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssert(delegate.routedResult == nil)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: {_ in 10})
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.routedResult!.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
        var receiveAnswers = [String:String]()
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
            receiveAnswers = answers
            return 20
            
        })
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.routedResult!.score, 20)
        XCTAssertEqual(receiveAnswers, ["Q1":"A1", "Q2":"A2"])
    }
    
    //MARK: helpers
    private func makeSUT(questions:[String], scoring: @escaping ([String: String]) -> Int = {_ in 0}) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: delegate, scoring: scoring)
    }
    
    private class RouterSpy: Router {
        
        var routedQuestions: [String] = []
        var routedResult: Result<String, String>? = nil
        var answerCallback: (String) -> Void = {_ in}
        func routeTo(question: String, answerCallback: @escaping (String) -> Void){
            
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String,String>) {
            routedResult = result
        }
    }
}

