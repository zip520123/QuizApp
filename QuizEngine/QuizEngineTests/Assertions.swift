//
//  Assertions.swift
//  QuizEngineTests_iOS_Test
//
//  Created by zip520123 on 01/02/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
import XCTest
func assertEqual(_ a1: [(String,String)], _ a2: [(String,String)], file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
}
