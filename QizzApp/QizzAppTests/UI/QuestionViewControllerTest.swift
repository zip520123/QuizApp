//
//  QuestionViewControllerTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 13/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
import XCTest
@testable import QizzApp
class QuestionViewControllerTest: XCTestCase {
    func test_viewDidload_renderQuestionHeaderTest() {
        let sut = makeSUT(question: "Q1", options: [])
        
        XCTAssert(sut.headerLabel.text == "Q1" )
    }
    
    func test_viewDidload_withNoOptions_renderOptions() {
        
        XCTAssert(makeSUT(options: []).tableView.numberOfRows(inSection: 0) == 0 )
        XCTAssert(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0) == 1 )
        XCTAssert(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0) == 2 )
    }
    
    func test_viewDidload_renderOneOptionsText() {
        XCTAssert(makeSUT(options: ["A1","A2"]).tableView.title(at: 0) == "A1")
        XCTAssert(makeSUT(options: ["A1","A2"]).tableView.title(at: 1) == "A2")
    }
    
    func test_viewDidload_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1","A2"], isMultipleSelection: false).tableView.allowsMultipleSelection)
    }
    
    func test_viewDidload_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1","A2"], isMultipleSelection: true).tableView.allowsMultipleSelection)
    }
    
    func test_optionSelected_withSingleSeletions_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1","A2"]) {
            receivedAnswer = $0
        }
        sut.tableView.select(at: 0)
        XCTAssert(receivedAnswer == ["A1"])
        sut.tableView.select(at: 1)
        XCTAssert(receivedAnswer == ["A2"])
    }
    
    func test_optionSelected_withSingleSeletions_doesNotNotifiesDelegateWithEmptySelection() {
        
        var callbackCount = 0
        let sut = makeSUT(options: ["A1","A2"]) { _ in
            callbackCount += 1
        }
        sut.tableView.select(at: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(at: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultiSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1","A2"], isMultipleSelection: true) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(at: 0)
        XCTAssert(receivedAnswer == ["A1"])

        sut.tableView.select(at: 1)
        XCTAssert(receivedAnswer == ["A1","A2"])
    }
    
    func test_optionDeselected_withMultiSelectionEnabled_notifiesDelegate() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1","A2"], isMultipleSelection: true) {
            receivedAnswer = $0
        }
        
        sut.tableView.select(at: 0)
        XCTAssert(receivedAnswer == ["A1"])
        
        sut.tableView.deselect(at: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    // MARK: Helpers
    func makeSUT(question: String = "",
                 options: [String] = [],
                 isMultipleSelection: Bool = false,
                 selection: @escaping (([String])->Void) = {_ in}
    ) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: isMultipleSelection , selection: selection)
        _ = sut.view
        
        return sut
    }
}

