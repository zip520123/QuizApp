//
//  BasicScore.swift
//  QizzApp
//
//  Created by zip520123 on 04/02/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
final class BasiceScore {
    static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
        return zip(answers, correctAnswers).reduce(0) { (res, tuple) in
            let (answer, correctAnswer) = tuple
            return res + (answer == correctAnswer ? 1 : 0)
        }
    }
}
