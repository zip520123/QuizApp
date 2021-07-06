//
//  MultipleAnswerQuestionSnapshotTests.swift
//  QizzAppTests
//
//  Created by zip520123 on 28/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import XCTest
@testable import QizzApp
class MultipleAnswerQuestionSnapshotTests: XCTestCase {
    func test() {
        let sut = MultipleAnswerQuestion(title: "A title", question: "A question", store: .init(options: ["Option 1", "Option 2"]))
        record(<#T##issue: XCTIssue##XCTIssue#>)
    }
}
