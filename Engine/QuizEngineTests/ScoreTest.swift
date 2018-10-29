//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
	
	func test_noAnswers_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
	}
	
	func test_oneWrongAnswer_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: ["wrong"], comparingTo: ["correct"]), 0)
	}
	
	func test_oneCorrectAnswer_scoresOne() {
		XCTAssertEqual(BasicScore.score(for: ["correct"], comparingTo: ["correct"]), 1)
	}
	
	func test_oneCorrectAnswerOneWrong_scoresOne() {
		let score = BasicScore.score(
			for: ["correct 1", "wrong"],
			comparingTo: ["correct 1", "correct 2"])
		
		XCTAssertEqual(score, 1)
	}

	private class BasicScore {
		static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
			var score = 0
			for (index, answer) in answers.enumerated() {
				score += (answer == correctAnswers[index]) ? 1 : 0
			}
			return score
		}
	}
	
}
