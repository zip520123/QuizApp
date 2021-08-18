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
    let options: [Question<String>:[String] ]
    let correctAnswers: [(Question<String>, [String])]
}
struct NonEmptyOptions {
    let head: String
    let tail: [String]
    var all: [String] {
        [head]+tail
    }
}
struct BasicQuizBuilder {
    private let questions: [Question<String>]
    private let options: [Question<String>:[String]]
    private let correctAnswers: [(Question<String>, [String])]
    
    enum AddingError: Error, Equatable {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options:[String])
    }
    init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        let allOptions = options.all
        guard allOptions.contains(answer) else {
            throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions)
        }
        guard Set(allOptions).count == allOptions.count else {
            throw AddingError.duplicateOptions(allOptions)
        }
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: [options.head] + options.tail]
        self.correctAnswers = [(question, [answer])]
    }
    func build() -> BasicQuiz {
        return BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
    }
}
class BasicQuizBuilderTests: XCTestCase {
    func test_initWithSingleAnswerQuestion() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2","o3"]),
            answer: "o1")
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1")])
        XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1","o2","o3"]])
        asserEqual(result.correctAnswers, [(.singleAnswer("q1"), ["o1"])])
    }
    
    func test_initWithSingleAnswerQuestion_duplicateOptions_throws() throws {
        XCTAssertThrowsError(try BasicQuizBuilder(
                                singleAnswerQuestion: "q1",
                                options: NonEmptyOptions(head: "o1", tail: ["o1","o3"]),
                                answer: "o1")) { error in
            
            XCTAssertEqual(error as? BasicQuizBuilder.AddingError, BasicQuizBuilder.AddingError.duplicateOptions(["o1","o1","o3"]))
        }
        
    }
    
    func test_initWithSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
        XCTAssertThrowsError(try BasicQuizBuilder(
                                singleAnswerQuestion: "q1",
                                options: NonEmptyOptions(head: "o1", tail: ["o2","o3"]),
                                answer: "o4")) { error in
            
            XCTAssertEqual(error as? BasicQuizBuilder.AddingError, BasicQuizBuilder.AddingError.missingAnswerInOptions(answer: ["o4"], options: ["o1","o2","o3"]))
        }
        
    }
    
    //MARK: - Helpers
    private func asserEqual(_ a1: [(Question<String>,[String])], _ a2:  [(Question<String>,[String])], file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not eqaul to \(a2)", file: file, line: line)
    }
}

