//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
	
	private let delegate = DelegateSpy()
	private var game: Game<String, String, DelegateSpy>!
	
	override func setUp() {
		super.setUp()
		
		game = startGame(questions: ["Q1", "Q2"], router: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
	}
	
	func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
		delegate.answerCallback("wrong")
		delegate.answerCallback("wrong")
		
		XCTAssertEqual(delegate.handledResult!.score, 0)
	}
	
	func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
		delegate.answerCallback("A1")
		delegate.answerCallback("wrong")
		
		XCTAssertEqual(delegate.handledResult!.score, 1)
	}
	
	func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
		delegate.answerCallback("A1")
		delegate.answerCallback("A2")
		
		XCTAssertEqual(delegate.handledResult!.score, 2)
	}
	
	private class DelegateSpy: Router {
		var handledResult: Result<String, String>? = nil
		
		var answerCallback: (String) -> Void = { _ in }
		
		func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
			self.answerCallback = answerCallback
		}
		
		func routeTo(result: Result<String, String>) {
			handledResult = result
		}
	}
	
}
