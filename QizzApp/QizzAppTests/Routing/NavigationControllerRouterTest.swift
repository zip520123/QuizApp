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
    
    func test_routeToSecondQuestion_showsQuestionController() {
        
        let viewController = UIViewController()
        let secondController = UIViewController()
        
        factory.stub(question:singleAnswerQuestion,with: viewController)
        factory.stub(question:multipleAnswerQuestion,with: secondController)
            
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in})
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in})
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        
        var callbackWasFired = false
        
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in callbackWasFired.toggle()})
        
        factory.answerCallBack[singleAnswerQuestion]!(["anything"])
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_singleAnswer_doseNotConfiguresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question:singleAnswerQuestion,with: viewController)
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        
        var callbackWasFired = false
        
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in callbackWasFired.toggle()})
        
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        XCTAssertFalse(callbackWasFired)
    }

    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in })
        
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallBack[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        
        factory.stub(question:multipleAnswerQuestion,with: viewController)
        
        var callbackWasFired = false
        
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in
            callbackWasFired = true
        })
        
        factory.answerCallBack[multipleAnswerQuestion]!(["anything"])
        
        
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
            
         
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsQuestionController() {
        
        let viewController = UIViewController()
        let result = Result.make(answers: [singleAnswerQuestion:["A1"]], score: 10)
        
        let secondViewController = UIViewController()
        let secondResult = Result.make(answers: [singleAnswerQuestion:["A2"]], score: 20)
        
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
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
        private var stubbedResults = Dictionary<Result<Question<String>,[String]>,UIViewController>()
        var answerCallBack = [Question<String>:([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        func stub(result: Result<Question<String>,[String]>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        func questionViewController(for question: Question<String>,  answerCallback:@escaping ([String])->Void) -> UIViewController {
            self.answerCallBack[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return stubbedResults[result, default: UIViewController()]
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
