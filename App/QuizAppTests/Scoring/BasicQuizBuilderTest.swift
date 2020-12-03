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
	private var questions: [Question<String>]
	private var options: [Question<String>: [String]]
	private var correctAnswers: [(Question<String>, [String])]
	
	enum AddingError: Equatable, Error {
		case duplicateOptions([String])
		case missingAnswerInOptions(answer: [String], options: [String])
		case duplicateQuestion(Question<String>)
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		let allOptions = options.all
		
		guard allOptions.contains(answer) else {
			throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions)
		}
		
		guard Set(allOptions).count == allOptions.count else {
			throw AddingError.duplicateOptions(allOptions)
		}
		
		let question = Question.singleAnswer(singleAnswerQuestion)
		self.questions = [question]
		self.options = [question: allOptions]
		self.correctAnswers = [(question, [answer])]
	}
	
	mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		let question = Question.singleAnswer(singleAnswerQuestion)
		
		guard !questions.contains(question) else {
			throw AddingError.duplicateQuestion(question)
		}
		
		let allOptions = options.all

		guard allOptions.contains(answer) else {
			throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions)
		}

		guard Set(allOptions).count == allOptions.count else {
			throw AddingError.duplicateOptions(allOptions)
		}


		var newOptions = self.options
		newOptions[question] = allOptions
		
		self.questions += [question]
		self.options = newOptions
		self.correctAnswers += [(question, [answer])]
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
		assert(
			try BasicQuizBuilder(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
				answer: "o1"
			),
			throws: .duplicateOptions(["o1", "o1", "o3"])
		)
	}
	
	func test_initWithSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		assert(
			try BasicQuizBuilder(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
				answer: "o4"
			),
			throws: .missingAnswerInOptions(answer: ["o4"], options: ["o1", "o2", "o3"])
		)
	}
	
	func test_addSingleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		try sut.add(
			singleAnswerQuestion: "q2",
			options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
			answer: "o3")
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1"), .singleAnswer("q2")])
		XCTAssertEqual(result.options, [
			.singleAnswer("q1"): ["o1", "o2", "o3"],
			.singleAnswer("q2"): ["o3", "o4", "o5"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("q1"), ["o1"]),
			(.singleAnswer("q2"), ["o3"])
		])
	}
	
	func test_addSingleAnswerQuestion_duplicateOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")

		assert(
			try sut.add(
				singleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
				answer: "o3"
			),
			throws: .duplicateOptions(["o3", "o3", "o5"])
		)
	}
	
	func test_addSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")

		assert(
			try sut.add(
				singleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: "o6"
			),
			throws: .missingAnswerInOptions(answer: ["o6"], options: ["o3", "o4", "o5"])
		)
	}
	
	func test_addSingleAnswerQuestion_duplicateQuestion_throw() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		assert(
			try sut.add(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: "o5"
			),
			throws: .duplicateQuestion(.singleAnswer("q1"))
		)
	}

	// MARK: - Helpers
	
	private func assertEqual(_ a1: [(Question<String>, [String])], _ a2: [(Question<String>, [String])], file: StaticString = #file, line: UInt = #line) {
		XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
	}
	
	func assert<T>(_ expression: @autoclosure () throws -> T, throws expectedError: BasicQuizBuilder.AddingError, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertThrowsError(try expression()) { error in
			XCTAssertEqual(
				error as? BasicQuizBuilder.AddingError,
				expectedError,
				file: file,
				line: line
			)
		}
	}

}
