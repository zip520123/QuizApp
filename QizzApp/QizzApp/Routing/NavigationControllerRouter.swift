//
//  NavigationControllerRouter.swift
//  QizzApp
//
//  Created by zip520123 on 10/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func answer(for question: QuizEngine.Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: completion))
        case .multibleAnswer:
            let button = UIBarButtonItem(title: "submit", style: .done, target: nil, action: nil)
            
            let submitButtonController = SubmitButtonController(button, completion)
            
            let controller = factory.questionViewController(for: question, answerCallback: { selection in
                submitButtonController.update(selection)
            })
            
            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        answer(for: question, completion: answerCallback)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: Question<String>, answers: [String])]) {
        show(factory.resultViewController(for: answers))
    }
    
    func routeTo(result: Result<Question<String>, [String]>) {
        show(factory.resultViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController: NSObject {
    let button: UIBarButtonItem
    let callback: ([String]) ->Void
    private var model: [String] = []
    init(_ button: UIBarButtonItem,_ callback: @escaping ([String])->Void) {
        self.button = button
        self.callback = callback
        super.init()
        self.setup()
    }
    
    func setup() {
        button.target = self
        button.action = #selector(fireCallback)
        updateButtonState()
    }
    
    func update(_ model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
}
