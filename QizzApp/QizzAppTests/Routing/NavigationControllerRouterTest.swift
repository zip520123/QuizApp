//
//  NavigationControllerRouterTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 10/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import XCTest
import UIKit
import QuizEngine
@testable import QizzApp

class NavigationControllerRouterTest: XCTestCase {
    let navigationController = NonAnimateNavigationController()
    let multipleAnswerQuestion = Question.multibleAnswer("Q1")
    let singleAnswerQuestion = Question.singleAnswer("Q2")
    let factory = ViewControllerFacotryStub()
    
    lazy var sut:NavigationControllerRouter = {
        NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    func test_answerForSecondQuestion_showsQuestionController() {
        
        let viewController = UIViewController()
        let secondController = UIViewController()
        
        factory.stub(question:singleAnswerQuestion,with: viewController)
        factory.stub(question:multipleAnswerQuestion,with: secondController)
            
        sut.answer(for: singleAnswerQuestion, completion: {_ in})
        sut.answer(for: multipleAnswerQuestion, completion: {_ in})
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        
        var callbackWasFired = false
        
        sut.answer(for: singleAnswerQuestion) { (_) in
            callbackWasFired = true
        }
        factory.answerCallBack[singleAnswerQuestion]!(["anything"])
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_singleAnswer_doseNotConfiguresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question:singleAnswerQuestion,with: viewController)
        sut.answer(for: singleAnswerQuestion, completion: {_ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        
        var callbackWasFired = false
        
        sut.answer(for: multipleAnswerQuestion, completion: {_ in callbackWasFired.toggle()})
        
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        XCTAssertFalse(callbackWasFired)
    }

    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        sut.answer(for: multipleAnswerQuestion, completion: {_ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        sut.answer(for: multipleAnswerQuestion, completion: {_ in })
        
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallBack[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        
        var callbackWasFired = false
        
        sut.answer(for: multipleAnswerQuestion, completion: {_ in
            callbackWasFired = true
        })
        
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        
        
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
            
         
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_showsQuestionController() {
        
        let viewController = UIViewController()
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        let secondViewController = UIViewController()
        let secondUserAnswers = [(singleAnswerQuestion, ["A2"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: viewController)
        factory.stub(resultForQuestions: [multipleAnswerQuestion], with: secondViewController)
        sut.didCompleteQuiz(withAnswers: userAnswers)
        
        sut.didCompleteQuiz(withAnswers: secondUserAnswers)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
        
        
    }
    
    //MARK: - Helpers
    
    class NonAnimateNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFacotryStub: ViewControllerFactory {
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = Dictionary<[Question<String>], UIViewController>()
        var answerCallBack = [Question<String>:([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        func stub(resultForQuestions questions: [Question<String>], with viewController: UIViewController) {
            stubbedResults[questions] = viewController
        }
        func questionViewController(for question: Question<String>,  answerCallback:@escaping ([String])->Void) -> UIViewController {
            self.answerCallBack[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return stubbedResults[userAnswers.map {$0.question}] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return UIViewController()
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
