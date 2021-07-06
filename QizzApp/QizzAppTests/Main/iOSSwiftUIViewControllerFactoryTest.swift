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
    
    
    func test_resultsViewController_createsControllerWithSummary() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())
        
        XCTAssertEqual(view.summary, presenter.summery)
    }
    
    func test_resultsViewController_createsControllerWithTitle() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())
        
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() throws {
        let (view, presenter) = try XCTUnwrap(makeResults())
        
        XCTAssertEqual(view.answers, presenter.presentableAnswers)
    }
    
    func test_resultsViewController_createsControllerWithPlayAgainAction() throws {
        var playAgainCount = 0
        let (view, presenter) = try XCTUnwrap(makeResults(playAgain: { playAgainCount += 1 }))
        
        XCTAssertEqual(playAgainCount, 0)
        view.playAgain()
        XCTAssertEqual(playAgainCount, 1)
        view.playAgain()
        XCTAssertEqual(playAgainCount, 2)
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
    private var userAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1","A2"])]
    }
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multibleAnswer("Q1") }
    
    private func makeSUT(playAgain: @escaping ()->Void = {}) -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers, playAgain: playAgain)
    }
    
    func makeMultipleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in} ) -> MultipleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<MultipleAnswerQuestion>
        return controller?.rootView
    }
    
    func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in }) -> SingleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>
        
        return controller?.rootView
    }

    func makeResults(playAgain: @escaping ()-> Void = {}) -> (view: ResultView, presenter: ResultsPresenter)? {
        let sut = makeSUT(playAgain: playAgain)
        let controller = sut.resultViewController(for: userAnswers) as? UIHostingController<ResultView>
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasiceScore.score)
        
        return controller.map { ($0.rootView, presenter) }
    }
    
}

