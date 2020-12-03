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
}

struct BasicQuizBuilder {
	private let questions: [Question<String>]
	private let options: [Question<String>: [String]]
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions) {
		let question = Question.singleAnswer(singleAnswerQuestion)
		self.questions = [question]
		self.options = [question: [options.head] + options.tail]
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options)
	}
}

class BasicQuizBuilderTest: XCTestCase {

    func test_initWithSingleAnswerQuestion() {
		let sut = BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]))
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1")])
		XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
    }

}
