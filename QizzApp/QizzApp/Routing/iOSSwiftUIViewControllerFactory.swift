//
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import SwiftUI
import QuizEngine

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]
    
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
            let presenter = QuestionPresenter(questions: questions, question: question)
            
            let controller = UIHostingController(rootView: SingleAnswerQuestion(title: presenter.title, question: value, options: options, selection: { answerCallback([$0]) }))
            
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
