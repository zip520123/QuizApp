//
//  iOSViewControllerFactoryTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 14/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//
import SwiftUI
import XCTest
import QuizEngine
@testable import QizzApp

class iOSSwiftUIViewControllerFactoryTest: XCTestCase {

    func test_questionViewController_singleAnswer_createControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: quesions, question: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    
    func test_questionViewController_singleAnswer_createControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createControllerWithOption() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createControllerWithAnswerCallback() throws {
        var answers = [[String]]()
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { (answers.append($0))
        }))
        
        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithTitle() throws {
        
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithOption() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
    }
    
    
    func test_resultsViewController_createsControllerWithSummary() {
        let result = makeResults()
        
        XCTAssertEqual(result.controller.summery, result.presenter.summery)
    }
    
    func test_resultsViewController_createsControllerWithTitle() {
        let result = makeResults()
        
        XCTAssertEqual(result.controller.title, result.presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let result = makeResults()
        
        
        XCTAssertEqual(result.controller.answers.count, result.presenter.presentableAnswers.count)
    }
    
    //MARK : Helpers
    private var quesions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    private var options: [Question<String>: [String]] {
        [singleAnswerQuestion:["A1", "A2", "A3"], multipleAnswerQuestion:["A4", "A5", "A6"]]
    }
    private var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4, A5"])]
    }
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multibleAnswer("Q1")
    
    func makeSUT(options: Dictionary<Question<String>,[String]> = [:], correctAnswers: [(Question<String>, [String])] = []) -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeMultipleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in} ) -> MultipleAnswerQuestion? {
        let sut = makeSUT(options: options,
                          correctAnswers: [(singleAnswerQuestion, []), (multipleAnswerQuestion, [])])
        let controller = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<MultipleAnswerQuestion>
        return controller?.rootView
    }
    
    func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in }) -> SingleAnswerQuestion? {
        let sut = makeSUT(options: options, correctAnswers: correctAnswers)
        let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>
        
        return controller?.rootView
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1","A2"])]
        let correcntAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1","A2"])]
        
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correcntAnswers,
            scorer: BasiceScore.score)
        
        let sut = makeSUT(correctAnswers: correcntAnswers)
        
        
        let controller = sut.resultViewController(for: userAnswers) as! ResultsViewController
        return (controller, presenter)
    }
    
}

