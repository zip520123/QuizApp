//
//  MultipleSelectionStoreTests.swift
//  QizzAppTests
//
//  Created by zip520123 on 02/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import XCTest
@testable import QizzApp

class MultipleSelectionStoreTests: XCTestCase {
    func test_selectOption_toggleState() {
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.canSubmit)
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)
        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
        
    }
    
    func test_submit_notifiesHandlerWithSelectedOption() {
        var sumbittedOptions = [[String]]()
        var sut = MultipleSelectionStore(options:["o0", "o1"], handler: {
            sumbittedOptions.append($0)
        })
        sut.submit()
        XCTAssertEqual(sumbittedOptions, [])
        
        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(sumbittedOptions, [["o0"]])
        
        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(sumbittedOptions, [["o0"], ["o0","o1"]])
        
    }
}
