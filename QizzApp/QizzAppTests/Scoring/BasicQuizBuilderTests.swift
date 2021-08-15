//
//  BasicQuizBuilderTests.swift
//  QizzAppTests
//
//  Created by zip520123 on 15/08/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import XCTest
import QuizEngine
struct BasicQuiz {
    let questions: [Question<String>]
}
struct BasicQuizBuilder {
    private let questions: [Question<String>]
    init(singleAnswerQuestion: String) {
        questions = [.singleAnswer(singleAnswerQuestion)]
    }
    func build() -> BasicQuiz {
        return BasicQuiz(questions: questions)
    }
}
class BasicQuizBuilderTests: XCTestCase {
    func test_initWithSingleAnswerQuestion() {
        let sut = BasicQuizBuilder(singleAnswerQuestion: "q1")
        
        XCTAssertEqual(sut.build().questions, [.singleAnswer("q1")])
    }
}
