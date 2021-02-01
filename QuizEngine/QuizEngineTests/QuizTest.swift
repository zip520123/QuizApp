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
    
    private var quiz: Quiz!
    func test_startQuiz_answersAllQuestions_completesWithAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1","Q2"], delegate: delegate)
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1","A1"),("Q2","A2")])
    }
    
    func test_startQuiz_answersAllQuestionsTwice_completesWithNewAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(questions: ["Q1","Q2"], delegate: delegate)
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1","A1"),("Q2","A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1","A1-1"),("Q2","A2-2")])
    }
}
