//
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
    
}
