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
    
    
    func test_start_withNoQuestions_doseNotDelegateQuestionHandling(){
        makeSUT(questions: []).start()
        XCTAssert(delegate.questionsAsked.isEmpty)
    }
    
    
    func test_start_withOneQuestions_delegatesCorrectQuestionHandling(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling(){
        
        makeSUT(questions:["Q2"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling(){
        
        makeSUT(questions:["Q1","Q2"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_start_twice_withTwoQuestions_delegatesFirstQuestionHandlingTwice(){
        let sut = makeSUT(questions:["Q1","Q2"])
        
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstAndSecendQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionOnHandling(){
        let sut = makeSUT(questions:["Q1","Q2", "Q3"])
        
        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1","Q2","Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAntherQuestionHandling(){
        let sut = makeSUT(questions:["Q1"])
        
        sut.start()
        delegate.answerCompletions[0]("A1")
        
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestion_doesNotCompleteQuiz(){
        makeSUT(questions:["Q1"]).start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestion_completeWithEmptyQuiz(){
        makeSUT(questions:[]).start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0],[("Q1","A1"), ("Q2","A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")
        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        
        assertEqual(delegate.completedQuizzes[0],[("Q1","A1"), ("Q2","A2")])
        assertEqual(delegate.completedQuizzes[1],[("Q1","A1-1"), ("Q2","A2-2")])
    }

    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    
    //MARK: helpers
    
    private let delegate = DelegateSpy()
    private weak var weakSUT: Flow<DelegateSpy, DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to SUT instance is not nil.")
    }
    
    private func makeSUT(questions:[String]) -> Flow<DelegateSpy, DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate, dataSource: delegate)
        weakSUT = sut
        return sut
    }
    
}

