//
//  DelegateSpy.swift
//  QuizEngineTests_iOS_Test
//
//  Created by zip520123 on 01/02/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate, QuizDataSource {
    
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []
    
    var completedQuizzes = [[(String,String)]]()
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
    
}
