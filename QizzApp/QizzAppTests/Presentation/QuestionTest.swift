//
//  QuestionTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 12/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import XCTest
@testable import QuizEngine
class QuestionTest: XCTestCase {
    func test_hashValue_withSameWrappedValue_isDifferentForSingleAndMultipleAnswer() {
        let aValue = UUID()
        XCTAssertNotEqual(
            Question.singleAnswer(aValue).hashValue,
            Question.multibleAnswer(aValue).hashValue)
    }
    
    func test_hashValue_singleAnswer_returnTypeHash() {
        let aValue = UUID()
        let anotherValue = UUID()
        XCTAssertEqual(
            Question.singleAnswer(aValue).hashValue,
            Question.singleAnswer(aValue).hashValue)
        
        XCTAssertNotEqual(
            Question.singleAnswer(aValue).hashValue,
            Question.singleAnswer(anotherValue).hashValue)
    }
    
    func test_hashValue_multipleAnswer() {
        let aValue = UUID()
        let anotherValue = UUID()
        XCTAssertEqual(
            Question.multibleAnswer(aValue).hashValue,
            Question.multibleAnswer(aValue).hashValue)
        
        XCTAssertNotEqual(
            Question.multibleAnswer(aValue).hashValue,
            Question.multibleAnswer(anotherValue).hashValue)
    }
    
    
    
}
