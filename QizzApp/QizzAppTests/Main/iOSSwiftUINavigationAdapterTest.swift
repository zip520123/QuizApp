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

class iOSSwiftUINavigationAdapterTest: XCTestCase {

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
    
    func test_answerForQuestion_replacesCurrentView() {
        let (sut, navigation) = makeSUT()
        sut.answer(for: singleAnswerQuestion) { _ in }
        
        XCTAssertNotNil(navigation.singleCurrentView)
        sut.answer(for: multipleAnswerQuestion) { _ in }
        XCTAssertNotNil(navigation.multipleCurrentView)
        
    }
    
    func test_didCompleteQuiz_replacesCurrentView() {
        let (sut, navigation) = makeSUT()
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertNotNil(navigation.resultCurrentView)
        
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertNotNil(navigation.resultCurrentView)
        
    }
    
    func test_publishesNavigationChanges() {
        let (sut, navigation) = makeSUT()
        var navigationChangeCount = 0
        let cancellable = navigation.objectWillChange.sink { navigationChangeCount += 1 }
        XCTAssertEqual(navigationChangeCount, 0)
        sut.answer(for: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationChangeCount, 1)
        
        sut.answer(for: multipleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationChangeCount, 2)
        
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertEqual(navigationChangeCount, 3)
        cancellable.cancel()
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
    
    private func makeSUT(playAgain: @escaping ()->Void = {}) -> (iOSSwiftUINavigationAdapter, QuizNavigationStore) {
        let navigation = QuizNavigationStore()
        let sut = iOSSwiftUINavigationAdapter(navigation: navigation, options: options, correctAnswers: correctAnswers, playAgain: playAgain)
        return (sut, navigation)
    }
    
    func makeMultipleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in} ) -> MultipleAnswerQuestion? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
        return navigation.multipleCurrentView
    }
    
    func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in }) -> SingleAnswerQuestion? {
        let (sut, navigation) = makeSUT()
        sut.answer(for: singleAnswerQuestion, completion: answerCallback)
        return navigation.singleCurrentView
        
    }

    func makeResults(playAgain: @escaping ()-> Void = {}) -> (view: ResultView, presenter: ResultsPresenter)? {
        let (sut, navigation) = makeSUT(playAgain: playAgain)
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        let view = navigation.resultCurrentView
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasiceScore.score)
        
        return view.map {($0, presenter)}
    }
    
}
extension QuizNavigationStore {
    var singleCurrentView: SingleAnswerQuestion? {
        if case let .single(view) = currentView {return view}
        return nil
    }
    var multipleCurrentView: MultipleAnswerQuestion? {
        if case let .multiple(view) = currentView {return view}
        return nil
    }
    var resultCurrentView: ResultView? {
        switch currentView {
            case .result(let view): return view
        default:
            return nil
        }
    }
}
