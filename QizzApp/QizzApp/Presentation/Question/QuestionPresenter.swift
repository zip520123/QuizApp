//
//  QuestionPresenter.swift
//  QizzApp
//
//  Created by zip520123 on 21/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
import QuizEngine
struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let index = questions.firstIndex(of: question) else { return "" }
        return "Question #\(index + 1)"
        
    }
}
