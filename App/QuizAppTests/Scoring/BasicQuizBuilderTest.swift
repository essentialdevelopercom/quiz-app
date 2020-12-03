//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import QuizEngine

struct BasicQuiz {
	let questions: [Question<String>]
	let options: [Question<String>: [String]]
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
	
	enum AddingError: Equatable, Error {
		case duplicateOptions([String])
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions) throws {
		let allOptions = options.all
		
		guard Set(allOptions).count == allOptions.count else {
			throw AddingError.duplicateOptions(allOptions)
		}
		
		let question = Question.singleAnswer(singleAnswerQuestion)
		self.questions = [question]
		self.options = [question: allOptions]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options)
	}
}

class BasicQuizBuilderTest: XCTestCase {

    func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]))
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1")])
		XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
    }
	
	func test_initWithSingleAnswerQuestion_duplicateOptions_throw() throws {
		XCTAssertThrowsError(
			try BasicQuizBuilder(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]))
		) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				BasicQuizBuilder.AddingError.duplicateOptions(["o1", "o1", "o3"])
			)
		}
	}

}
