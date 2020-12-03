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
	private var questions: [Question<String>] = []
	private var options: [Question<String>: [String]] = [:]
	private var correctAnswers: [(Question<String>, [String])] = []
	
	enum AddingError: Equatable, Error {
		case duplicateQuestion(Question<String>)
		case duplicateOptions([String])
		case missingAnswerInOptions(answer: [String], options: [String])
	}
	
	private init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [(Question<String>, [String])]) {
		self.questions = questions
		self.options = options
		self.correctAnswers = correctAnswers
	}
	
	init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	init(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
	
	mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		self = try adding(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
	
	func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
		try adding(
			question: Question.singleAnswer(singleAnswerQuestion),
			options: options.all,
			answer: [answer]
		)
	}
	
	func adding(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws -> BasicQuizBuilder {
		try adding(
			question: Question.multipleAnswer(multipleAnswerQuestion),
			options: options.all,
			answer: answer.all
		)
	}
	
	func build() -> BasicQuiz {
		BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
	}
	
	private func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
		guard !questions.contains(question) else {
			throw AddingError.duplicateQuestion(question)
		}
		
		guard Set(options).count == options.count else {
			throw AddingError.duplicateOptions(options)
		}
		
		guard Set(answer).count == answer.count else {
			throw AddingError.duplicateAnswers(answer)
		}
		
		guard Set(answer).isSubset(of: Set(options)) else {
			throw AddingError.missingAnswerInOptions(answer: answer, options: options)
		}
		
		var newOptions = self.options
		newOptions[question] = options
		
		return BasicQuizBuilder(
			questions: questions + [question],
			options: newOptions,
			correctAnswers: correctAnswers + [(question, answer)]
		)
	}
}

class BasicQuizBuilderTest: XCTestCase {
	
	// MARK - Single Answer Question
	
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
	
	func test_addingSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1"
		).adding(
			singleAnswerQuestion: "q2",
			options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
			answer: "o3"
		)
		
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
	
	func test_addingSingleAnswerQuestion_duplicateOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
				answer: "o3"
			),
			throws: .duplicateOptions(["o3", "o3", "o5"])
		)
	}
	
	func test_addingSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: "o6"
			),
			throws: .missingAnswerInOptions(answer: ["o6"], options: ["o3", "o4", "o5"])
		)
	}
	
	func test_addingSingleAnswerQuestion_duplicateQuestion_throw() throws {
		let sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: "o1")
		
		assert(
			try sut.adding(
				singleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: "o5"
			),
			throws: .duplicateQuestion(.singleAnswer("q1"))
		)
	}
	
	// MARK - Multiple Answer Question
	
	func test_initWithMultipleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o2"]))
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("q1")])
		XCTAssertEqual(result.options, [.multipleAnswer("q1"): ["o1", "o2", "o3"]])
		assertEqual(result.correctAnswers, [(.multipleAnswer("q1"), ["o1", "o2"])])
	}
	
	func test_initWithMultipleAnswerQuestion_duplicateOptions_throw() throws {
		assert(
			try BasicQuizBuilder(
				multipleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
				answer: NonEmptyOptions(head: "o1", tail: ["o3"])
			),
			throws: .duplicateOptions(["o1", "o1", "o3"])
		)
	}
	
	func test_initWithMultipleAnswerQuestion_duplicateAnswers_throw() throws {
		assert(
			try BasicQuizBuilder(
				multipleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
				answer: NonEmptyOptions(head: "o1", tail: ["o1", "o2"])
			),
			throws: .duplicateAnswers(["o1", "o1", "o2"])
		)
	}
	
	func test_initWithMultipleAnswerQuestion_missingAnswerInOptions_throw() throws {
		assert(
			try BasicQuizBuilder(
				multipleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
				answer: NonEmptyOptions(head: "o1", tail: ["o4"])
			),
			throws: .missingAnswerInOptions(answer: ["o1", "o4"], options: ["o1", "o2", "o3"])
		)
	}
	
	func test_addMultipleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o2"]))
		
		try sut.add(
			multipleAnswerQuestion: "q2",
			options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
			answer: NonEmptyOptions(head: "o3", tail: ["o5"]))
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("q1"), .multipleAnswer("q2")])
		XCTAssertEqual(result.options, [
			.multipleAnswer("q1"): ["o1", "o2", "o3"],
			.multipleAnswer("q2"): ["o3", "o4", "o5"]
		])
		assertEqual(result.correctAnswers, [
			(.multipleAnswer("q1"), ["o1", "o2"]),
			(.multipleAnswer("q2"), ["o3", "o5"])
		])
	}
	
	func test_addMultipleAnswerQuestion_duplicateOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.add(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o5"])
			),
			throws: .duplicateOptions(["o3", "o3", "o5"])
		)
	}
	
	func test_addMultipleAnswerQuestion_duplicateAnswers_throw() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.add(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o3", "o4"])
			),
			throws: .duplicateAnswers(["o3", "o3", "o4"])
		)
	}
	
	func test_addMultipleAnswerQuestion_missingAnswerInOptions_throw() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.add(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o6", tail: ["o7"])
			),
			throws: .missingAnswerInOptions(answer: ["o6", "o7"], options: ["o3", "o4", "o5"])
		)
	}
	
	func test_addMultipleAnswerQuestion_duplicateQuestion_throw() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.add(
				multipleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o4"])
			),
			throws: .duplicateQuestion(.multipleAnswer("q1"))
		)
	}
	
	func test_addingMultipleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"])
		).adding(
			multipleAnswerQuestion: "q2",
			options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
			answer: NonEmptyOptions(head: "o4", tail: ["o5"])
		)
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("q1"), .multipleAnswer("q2")])
		XCTAssertEqual(result.options, [
			.multipleAnswer("q1"): ["o1", "o2", "o3"],
			.multipleAnswer("q2"): ["o3", "o4", "o5"]
		])
		assertEqual(result.correctAnswers, [
			(.multipleAnswer("q1"), ["o1", "o3"]),
			(.multipleAnswer("q2"), ["o4", "o5"])
		])
	}
	
	func test_addingMultipleAnswerQuestion_duplicateOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.adding(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o5"])
			),
			throws: .duplicateOptions(["o3", "o3", "o5"])
		)
	}
	
	func test_addingMultipleAnswerQuestion_duplicateAnswers_throw() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.adding(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o3", "o4"])
			),
			throws: .duplicateAnswers(["o3", "o3", "o4"])
		)
	}
	
	func test_addingMultipleAnswerQuestion_missingAnswerInOptions_throw() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.adding(
				multipleAnswerQuestion: "q2",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o6", tail: ["o7"])
			),
			throws: .missingAnswerInOptions(answer: ["o6", "o7"], options: ["o3", "o4", "o5"])
		)
	}
	
	func test_addingMultipleAnswerQuestion_duplicateQuestion_throw() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
			answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
		
		assert(
			try sut.adding(
				multipleAnswerQuestion: "q1",
				options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
				answer: NonEmptyOptions(head: "o3", tail: ["o5"])
			),
			throws: .duplicateQuestion(.multipleAnswer("q1"))
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
