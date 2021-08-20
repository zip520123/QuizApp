//
//  iOSViewControllerFactoryTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 14/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import XCTest
import QuizEngine
@testable import QizzApp

class iOSUIKitViewControllerFactoryTest: XCTestCase {
    let options = ["A1","A2"]
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multibleAnswer("Q1")
    private var quesions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    func test_questionViewController_singleAnswer_createControllerWithTitle() {
        
        let presenter = QuestionPresenter(questions: quesions, question: singleAnswerQuestion)
        let controller = makeQuestionController(question: singleAnswerQuestion)
        XCTAssertEqual(controller.title, presenter.title)
    }
    
    
    func test_questionViewController_singleAnswer_createControllerWithQuestion() {
        let controller = makeQuestionController(question: singleAnswerQuestion)
       XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createControllerWithOption() {
        let controller = makeQuestionController()
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_singleAnswer_createControllerWithSingleSelection() {
        
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithTitle() {
        
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        XCTAssertEqual(controller.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithQuestion() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithOption() {
        let controller = makeQuestionController()
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewController_multipleAnswer_createControllerWithSingleSelection() {
        
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
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
    
    func makeSUT(options: Dictionary<Question<String>,[String]> = [:], correctAnswers: [(Question<String>, [String])] = []) -> iOSUIKitViewControllerFactory {
        return iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        let sut = makeSUT(options: [question: options],
                          correctAnswers: [(singleAnswerQuestion, []), (multipleAnswerQuestion, [])])
        return sut.questionViewController(for: question) { (_) in
            
        } as! QuestionViewController
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

