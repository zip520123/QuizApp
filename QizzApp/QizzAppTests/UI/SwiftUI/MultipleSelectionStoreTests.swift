//
//  MultipleSelectionStoreTests.swift
//  QizzAppTests
//
//  Created by zip520123 on 02/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import XCTest
struct MultipleSelectionStore {
    var canSubmit : Bool {
        options.filter{ $0.isSelected }.endIndex > 0
    }
    
    var options: [MultipleSelectionOption]
    internal init(options: [String]) {
        self.options = options.map {MultipleSelectionOption(text: $0)}
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    mutating func select() {
        isSelected.toggle()
    }
}

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
}
