//
//  Flow.swift
//  QuizEngine
//
//  Created by zip520123 on 08/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation

final class Flow <Delegate: QuizDelegate, DataSource: QuizDataSource> where Delegate.Question == DataSource.Question, Delegate.Answer == DataSource.Answer{
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [(Question, Answer)] = []
    private let dataSource: DataSource
    
    init(questions:[Question], delegate: Delegate, dataSource: DataSource){
        self.delegate = delegate
        self.questions = questions
        self.dataSource = dataSource
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            dataSource.answer(for: question, completion: answer(for: question, at: index))
        } else {
            delegate.didCompleteQuiz(withAnswers: answers)
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(for question:Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.answers.replaceOrInsert((question, answer), at: index)
            self?.delegateQuestionHandling(after: index )

        }
    }
    
}

private extension Array {
    mutating func replaceOrInsert(_ element: Element, at index: Index) {
        if index < endIndex {
            remove(at: index)
        }
        insert(element, at: index)
    }
}
