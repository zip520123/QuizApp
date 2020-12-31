//
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback:@escaping ([String])->Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
