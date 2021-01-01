//
//  ResultHelper.swift
//  QizzAppTests
//
//  Created by zip520123 on 13/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
@testable import QuizEngine
extension Result {
    static func make(answers: [Question:Answer], score: Int) -> Result {
        return Result(answers: answers, score: score)
    }
}

extension Result: Equatable where Answer: Equatable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.answers == rhs.answers && lhs.score == rhs.score
    }
}

extension Result: Hashable where Answer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(score)
    }
}
