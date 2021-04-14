//
//  iOSViewControllerFactory.swift
//  QizzApp
//
//  Created by zip520123 on 14/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

final class iOSViewControllerFactory: ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Answers
    private var questions: [Question<String>] {
        return correctAnswers.map {$0.question}
    }
    
    init(options: Dictionary<Question<String>, [String]>, correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        
        switch question {
        case .singleAnswer(let value):
            let controller = questionViewController(question:question, value:  value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
            
            return controller
        case .multibleAnswer(let value):
            return questionViewController(question: question, value: value, options: options, allowsMultipleSelection: true , answerCallback: answerCallback)
            
        }
    }
    
    private func questionViewController(question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool , answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {

        let presenter = ResultsPresenter(userAnswers: questions.map({ (question) in
            (question, result.answers[question]!)
        }), correctAnswers: correctAnswers , scorer: { _, _ in result.score})
        
        let controller = ResultsViewController(summery: presenter.summery, answers:presenter.presentableAnswers)
        controller.title = presenter.title
        
        return controller
    }
    
    func resultViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasiceScore.score)
        
        let controller = ResultsViewController(summery: presenter.summery, answers:presenter.presentableAnswers)
        controller.title = presenter.title
        
        return controller
    }
}
