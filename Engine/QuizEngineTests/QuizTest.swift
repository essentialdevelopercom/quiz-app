//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
	
	private var quiz: Quiz?
	
	func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
		let delegate = DelegateSpy()

		quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

		delegate.answerCompletion("A1")
		delegate.answerCompletion("A2")
		
		XCTAssertEqual(delegate.completedQuizzes.count, 1)
		assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
	}
	
	private func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file, line: UInt = #line) {
		XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
	}

	private class DelegateSpy: QuizDelegate {
		var completedQuizzes: [[(String, String)]] = []
		var answerCompletion: (String) -> Void = { _ in }
		
		func answer(for question: String, completion: @escaping (String) -> Void) {
			self.answerCompletion = completion
		}
		
		func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
			completedQuizzes.append(answers)
		}
		
		func handle(result: Result<String, String>) {}
	}

	
}
