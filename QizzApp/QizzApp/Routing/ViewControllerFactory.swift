//
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]
    func questionViewController(for question: Question<String>, answerCallback:@escaping ([String])->Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
    func resultViewController(for userAnswers: [(question: Question<String>, answer: [String])]) -> UIViewController
}


