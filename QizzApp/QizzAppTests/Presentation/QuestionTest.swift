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
    func test_hashValue_isEqual() {
        XCTAssertEqual(Question.singleAnswer("a string").hashValue, Question.singleAnswer("a string").hashValue)
    }
    
    func test_hashValue_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("a string").hashValue, Question.singleAnswer("another string").hashValue)
    }
    
    
    
}
