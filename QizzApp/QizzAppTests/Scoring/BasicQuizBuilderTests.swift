//
//  BasicQuizBuilderTests.swift
//  QizzAppTests
//
//  Created by zip520123 on 15/08/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import XCTest
struct BasicQuiz {}
struct BasicQuizBuilder {
    func build() -> BasicQuiz? {
        return nil
    }
}
class BasicQuizBuilderTests: XCTestCase {
    func test_empty() {
        let sut = BasicQuizBuilder()
        XCTAssertNil(sut.build())
    }
}
