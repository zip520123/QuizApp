//
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]
    func questionViewController(for question: Question<String>, answerCallback:@escaping ([String])->Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
    func resultViewController(for userAnswers: [(question: Question<String>, answers: [String])]) -> UIViewController
}

extension ViewControllerFactory {
    func resultViewController(for userAnswers: Answers) -> UIViewController {
        return UIViewController()
    }
}
