//
//  Game.swift
//  QuizEngineTests
//
//  Created by zip520123 on 06/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available (*, deprecated)
public class Game<Question, Answer, R:Router> {
    let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R:Router>(questions:[Question], router: R, correctAnswers:[Question: Answer]) -> Game<Question, Answer, R> where Question == R.Question, Answer == R.Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router)) { scoring($0, correctAnswers: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

@available(*,deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    let router: R
    init(_ router: R) {
        self.router = router
    }
    
    func answer(for question: R.Question, completion: @escaping (Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func handle(result: Result<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }
}
