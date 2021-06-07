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
    private let handler: ([String])->Void
    
    internal init(options: [String], handler: @escaping ([String])-> Void = {_ in}) {
        self.options = options.map {MultipleSelectionOption(text: $0)}
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else {return}
        handler(options.filter{ $0.isSelected }.map {$0.text})
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
