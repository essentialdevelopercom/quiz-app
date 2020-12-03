//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import QuizEngine

struct BasicQuiz {
	let questions: [Question<String>]
	let options: [Question<String>: [String]]
	let correctAnswers: [(Question<String>, [String])]
}

struct NonEmptyOptions {
	let head: String
	let tail: [String]
	
	var all: [String] {
		[head] + tail
	}
}

struct BasicQuizBuilder {
	private let questions: [Question<String>]
	private let options: [Question<String>: [String]]
	private let correctAnswers: [(Question<String>, [String])]
	
	enum AddingError: Equatable, Error {
		case duplicateOptions([String])
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		let allOptions = options.all
		
		guard Set(allOptions).count == allOptions.count else {
			throw AddingError.duplicateOptions(allOptions)
		}
		
		let question = Question.singleAnswer(singleAnswerQuestion)
		self.questions = [question]
		self.options = [question: allOptions]
		self.correctAnswers = [(question, [answer])]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
	}
}

class BasicQuizBuilderTest: XCTestCase {

    func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1")])
		XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
		assertEqual(result.correctAnswers, [(.singleAnswer("q1"), ["o1"])])
    }
	
	func test_initWithSingleAnswerQuestion_duplicateOptions_throw() throws {
		XCTAssertThrowsError(
			try BasicQuizBuilder(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
				answer: "o1")
		) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				BasicQuizBuilder.AddingError.duplicateOptions(["o1", "o1", "o3"])
			)
		}
	}

	// MARK: - Helpers
	
	private func assertEqual(_ a1: [(Question<String>, [String])], _ a2: [(Question<String>, [String])], file: StaticString = #file, line: UInt = #line) {
		XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
	}

}
