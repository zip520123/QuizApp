//
//  ResultsPresenterTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 18/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import QuizEngine
import XCTest

@testable import QizzApp
class ResultsPresenterTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multibleAnswer("Q2")
    
    func test_title_returnsFormattedTitle() {
        
        let result: Result<Question<String>, Array<String>> = Result.make(answers: [:], score: 1)
        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])
        XCTAssertEqual(sut.title, "Result")
    }
    
    func test_summery_withTwoQuestionAndScoreOne_returnsSummery() {
        let answers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion:["A2","A3"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion:["A2"]]
        let orderedQuestions = [singleAnswerQuestion,multipleAnswerQuestion]
        let result = Result.make(answers: answers, score: 1)
        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)
        XCTAssertEqual(sut.summery, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withQuestions_shouldBeEmpty() {
        let answers = Dictionary<Question<String>,[String]>()
        
        let result = Result.make(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: ["A2"]]
        let result = Result.make(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers = [multipleAnswerQuestion: ["A1","A4"]]
        let correctAnswers = [multipleAnswerQuestion: ["A2","A3"]]
        let result = Result.make(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, questions: [multipleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let answers = [multipleAnswerQuestion:["A1","A4"], singleAnswerQuestion: ["A2"]]
        let correctAnswers = [multipleAnswerQuestion:["A1","A4"], singleAnswerQuestion: ["A2"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]

        let result = Result.make(answers: answers, score: 0)
        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)

    }
}
