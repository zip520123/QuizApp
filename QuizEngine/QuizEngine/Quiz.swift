//
//  Quiz.swift
//  QuizEngineTests
//
//  Created by zip520123 on 21/01/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
public final class Quiz {
    private let flow: Any
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions:[Question], delegate: Delegate, correctAnswers:[Question: Answer]) -> Quiz where Question == Delegate.Question, Answer == Delegate.Answer {
        let flow = Flow(questions: questions, delegate: delegate) { scoring($0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}
