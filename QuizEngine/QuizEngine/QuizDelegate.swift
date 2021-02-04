//
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
public protocol QuizDataSource {
    associatedtype Question
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
}

public protocol QuizDelegate {
    associatedtype Question
    associatedtype Answer

    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
}
