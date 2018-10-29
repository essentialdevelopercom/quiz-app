//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizApp

class ScoreTest: XCTestCase {
	
	func test_noAnswers_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: [String](), comparingTo: [String]()), 0)
	}
	
	func test_oneNonMatchingAnswer_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: ["not a match"], comparingTo: ["an answer"]), 0)
	}
	
	func test_oneMatchingAnswer_scoresOne() {
		XCTAssertEqual(BasicScore.score(for: ["an answer"], comparingTo: ["an answer"]), 1)
	}
	
	func test_oneMatchingAnswerOneNonMatching_scoresOne() {
		let score = BasicScore.score(
			for: ["an answer", "not a match"],
			comparingTo: ["an answer", "another answer"])
		
		XCTAssertEqual(score, 1)
	}

	func test_twoMatchingAnswers_scoresTwo() {
		let score = BasicScore.score(
			for: ["an answer", "another answer"],
			comparingTo: ["an answer", "another answer"])
		
		XCTAssertEqual(score, 2)
	}
	
	func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
		let score = BasicScore.score(
			for: ["an answer", "another answer", "an extra answer"],
			comparingTo: ["an answer", "another answer"])
		
		XCTAssertEqual(score, 2)
	}

	func test_withTooManyCorrectAnswers_oneMatchingAnswers_scoresOne() {
		let score = BasicScore.score(
			for: ["not matching", "another answer"],
			comparingTo: ["an answer", "another answer", "an extra answer"])
		
		XCTAssertEqual(score, 1)
	}
	
}
