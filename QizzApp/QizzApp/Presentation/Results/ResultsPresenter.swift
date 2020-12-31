//
//  ResultsPresenter.swift
//  QizzApp
//
//  Created by zip520123 on 18/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    let result : Result<Question<String>,[String]>
    let questions: [Question<String>]
    let correctAnswers: Dictionary<Question<String>,[String]>
    var summery: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var title: String {
        return "Result"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { (question) in
            guard let userAnswer = result.answers[question],
                let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswer, correctAnswer)
            
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswer: [String], _ correctAnswer:[String]) -> PresentableAnswer {
        
        
        switch question {
        case .singleAnswer(let value), .multibleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
            
        }
        
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswer:[String], _ correctAnswer:[String]) -> String? {
        return userAnswer == correctAnswer ? nil : formattedAnswer(userAnswer)
    }
}
