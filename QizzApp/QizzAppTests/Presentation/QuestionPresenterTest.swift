//
//  QuestionPresenterTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 21/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import XCTest
import QuizEngine
@testable import QizzApp

class QuestionPresenterTest: XCTestCase {
    let question1 = Question.singleAnswer("A1")
    let question2 = Question.multibleAnswer("A2")
    
    func test_title_forFristQuestion_formateTitleForIndex() {
        
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_forSecondQuestion_formateTitleForIndex() {
        
        
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forUnexistentQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("A1"))
        
        XCTAssertEqual(sut.title, "")
    }
}
