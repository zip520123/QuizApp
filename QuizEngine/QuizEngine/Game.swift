//
//  Game.swift
//  QuizEngineTests
//
//  Created by zip520123 on 06/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation

public class Game<Question, Answer, R:Router> where Question == R.Question, Answer == R.Answer {
    let flow: Flow<Question, Answer, R>
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer: Equatable, R:Router>(questions:[Question], router: R, correctAnswers:[Question: Answer]) -> Game<Question, Answer, R> where Question == R.Question, Answer == R.Answer {
    let flow = Flow(questions: questions, router: router) { scoring($0, correctAnswers: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        if correctAnswers[tuple.key] == tuple.value {
            return score + 1
        } else {
            return score
        }
    }
}
