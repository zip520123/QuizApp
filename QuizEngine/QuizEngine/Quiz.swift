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
    
    public static func start<Delegate: QuizDelegate>(
        questions:[Delegate.Question],
        delegate: Delegate,
        correctAnswers:[Delegate.Question: Delegate.Answer]
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(
            questions: questions,
            delegate: delegate) { scoring($0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        if correctAnswers[tuple.key] == tuple.value {
            return score + 1
        } else {
            return score
        }
    }
}
 
