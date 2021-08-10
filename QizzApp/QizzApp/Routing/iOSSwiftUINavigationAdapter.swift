//
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import SwiftUI
import QuizEngine
class QuizNavigationStore: ObservableObject {
    enum CurrentView {
        case single(SingleAnswerQuestion)
        case multiple(MultipleAnswerQuestion)
        case result(ResultView)
    }
    @Published var currentView: CurrentView?
}
final class iOSSwiftUINavigationAdapter: QuizDelegate, QuizDataSource {
    
    typealias Question = QuizEngine.Question<String>
    
    typealias Answer = [String]
    
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let options: Dictionary<Question, Answer>
    private let navigation: QuizNavigationStore
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    private var questions: [Question] {
        return correctAnswers.map {$0.question}
    }
    
    init(navigation: QuizNavigationStore, options: Dictionary<Question, Answer>, correctAnswers: Answers, playAgain: @escaping ()->Void) {
        self.navigation = navigation
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question")
        }
        
        let presenter = QuestionPresenter(questions: questions, question: question)
        switch question {
        case .singleAnswer(let value):
            navigation.currentView = .single(SingleAnswerQuestion(title: presenter.title, question: value, options: options, selection: { completion([$0]) }))
            
        case .multibleAnswer(let value):
            navigation.currentView = .multiple(MultipleAnswerQuestion(title: presenter.title, question: value, store: .init(options: options, handler: completion)))
            
        }
    }
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasiceScore.score)
//
//        return UIHostingController<ResultView>(rootView: ResultView(title: presenter.title, summary: presenter.summery, answers: presenter.presentableAnswers, playAgain: playAgain))
        navigation.currentView = .result(ResultView(title: presenter.title, summary: presenter.summery, answers: presenter.presentableAnswers, playAgain: playAgain))
    }
    
    private func questionViewController(for question: Question, answerCallback: @escaping (Answer) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question, options: Answer, answerCallback: @escaping (Answer) -> Void) -> UIViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        switch question {
        case .singleAnswer(let value):
            let controller = UIHostingController(rootView: SingleAnswerQuestion(title: presenter.title, question: value, options: options, selection: { answerCallback([$0]) }))
            
            return controller
        case .multibleAnswer(let value):
            let controller = UIHostingController(rootView: MultipleAnswerQuestion(title: presenter.title, question: value, store: .init(options: options, handler: answerCallback)))
            
            return controller
            
        }
    }
    
    private func questionViewController(question: Question, value: String, options: Answer, allowsMultipleSelection: Bool , answerCallback: @escaping (Answer) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
    private func resultViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasiceScore.score)
        
        return UIHostingController<ResultView>(rootView: ResultView(title: presenter.title, summary: presenter.summery, answers: presenter.presentableAnswers, playAgain: playAgain))
    }
}
