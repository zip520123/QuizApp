//
//  ResultViewControllerTest.swift
//  QizzAppTests
//
//  Created by zip520123 on 02/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
import XCTest
@testable import QizzApp
class ResultViewControllerTest: XCTestCase {
    func test_viewDidLoad_renderSummary() {
        XCTAssertEqual(makeSUT(summery: "a summery").headerLabel.text, "a summery")
    }
    
    
    func test_viewDidLoad_renderAnswers() {
        
        XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer() ]).tableView.numberOfRows(inSection: 0), 1)
        
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let anwser = makeAnswer(question:"Q1",answer:"A1")
        let sut = makeSUT(answers:[anwser])

        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    
    
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let anwser = makeAnswer(question:"Q1", answer:"A1", wrongAnswer: "wrong")
        let sut = makeSUT(answers:[anwser])
        
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "wrong")
    }
    
    //MARK: - helper
    
    func makeSUT(summery: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summery: summery, answers: answers)
        _ = sut.view
        return sut
    }
    
    
    
    func makeAnswer(question: String = "", answer: String = "" ,wrongAnswer: String? = nil) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer )
    }
}
