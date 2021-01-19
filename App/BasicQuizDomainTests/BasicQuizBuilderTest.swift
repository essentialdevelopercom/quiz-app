//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import BasicQuizDomain

class BasicQuizBuilderTest: XCTestCase {
	
	// MARK - Single Answer Question
	
	func test_initWithSingleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(singleAnswerQuestion: "q1", options: ["o1", "o2", "o3"], answer: "o1")
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1")])
		XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
		assertEqual(result.correctAnswers, [(.singleAnswer("q1"), ["o1"])])
	}
	
	func test_addSingleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(singleAnswerQuestion: "q1", options: ["o1", "o2"], answer: "o1")
		
		try sut.add(singleAnswerQuestion: "q2", options: ["o3", "o4"], answer: "o3")
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.singleAnswer("q1"), .singleAnswer("q2")])
		XCTAssertEqual(result.options, [
			.singleAnswer("q1"): ["o1", "o2"],
			.singleAnswer("q2"): ["o3", "o4"]
		])
		assertEqual(result.correctAnswers, [
			(.singleAnswer("q1"), ["o1"]),
			(.singleAnswer("q2"), ["o3"])
		])
	}
	
	func test_addingSingleAnswerQuestion() throws {
		let result = try BasicQuizBuilder(singleAnswerQuestion: "q1", options: ["o1", "o2", "o3"], answer: "o1")
			.adding(singleAnswerQuestion: "q2", options: ["o3", "o4", "o5"], answer: "o3")
			.build()
		
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
	
	func test_initWithSingleAnswerQuestion_invalidData_throws() throws {
		let params: [(q: String, o: NonEmptyOptions, a: String, e: BasicQuizBuilder.AddingError)] = [
			("q1", ["o1", "o1", "o3"], "o1", .duplicateOptions(["o1", "o1", "o3"])),
			("q1", ["o1", "o2", "o3"], "o4", .missingAnswerInOptions(answer: ["o4"], options: ["o1", "o2", "o3"]))
		]
		
		try params.forEach { (q, o, a, e) in
			assert(try BasicQuizBuilder(singleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	func test_addSingleAnswerQuestion_invalidData_throws() throws {
		var sut = try BasicQuizBuilder(
			singleAnswerQuestion: "q1",
			options: ["o1", "o2", "o3"],
			answer: "o1")
		
		let params: [(q: String, o: NonEmptyOptions, a: String, e: BasicQuizBuilder.AddingError)] = [
			("q1", ["o3", "o4", "o5"], "o3", .duplicateQuestion(.singleAnswer("q1"))),
			("q2", ["o3", "o3", "o5"], "o3", .duplicateOptions(["o3", "o3", "o5"])),
			("q2", ["o3", "o4", "o5"], "o6", .missingAnswerInOptions(answer: ["o6"], options: ["o3", "o4", "o5"]))
		]
		
		try params.forEach { (q, o, a, e) in
			assert(try sut.add(singleAnswerQuestion: q, options: o, answer: a), throws: e)
			assert(try sut.adding(singleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	// MARK - Multiple Answer Question
	
	func test_initWithMultipleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(multipleAnswerQuestion: "q1", options: ["o1", "o2", "o3"], answer: ["o1", "o2"])
		
		let result = sut.build()
		
		XCTAssertEqual(result.questions, [.multipleAnswer("q1")])
		XCTAssertEqual(result.options, [.multipleAnswer("q1"): ["o1", "o2", "o3"]])
		assertEqual(result.correctAnswers, [(.multipleAnswer("q1"), ["o1", "o2"])])
	}
	
	func test_addMultipleAnswerQuestion() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: ["o1", "o2", "o3"],
			answer: ["o1", "o2"])
		
		try sut.add(
			multipleAnswerQuestion: "q2",
			options: ["o3", "o4", "o5"],
			answer: ["o3", "o5"])
		
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
	
	func test_addingMultipleAnswerQuestion() throws {
		let sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: ["o1", "o2", "o3"],
			answer: ["o1", "o3"]
		).adding(
			multipleAnswerQuestion: "q2",
			options: ["o3", "o4", "o5"],
			answer: ["o4", "o5"]
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
	
	func test_initWithMultipleAnswerQuestion_invalidData_throws() throws {
		let params: [(q: String, o: NonEmptyOptions, a: NonEmptyOptions, e: BasicQuizBuilder.AddingError)] = [
			("q1", ["o1", "o1", "o3"], ["o1", "o3"], .duplicateOptions(["o1", "o1", "o3"])),
			("q1", ["o1", "o2", "o3"], ["o1", "o1", "o2"], .duplicateAnswers(["o1", "o1", "o2"])),
			("q1", ["o1", "o2", "o3"], ["o4"], .missingAnswerInOptions(answer: ["o4"], options: ["o1", "o2", "o3"]))
		]
		
		try params.forEach { (q, o, a, e) in
			assert(try BasicQuizBuilder(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	func test_addMultipleAnswerQuestion_invalidData_throws() throws {
		var sut = try BasicQuizBuilder(
			multipleAnswerQuestion: "q1",
			options: ["o1", "o2", "o3"],
			answer: ["o1", "o3"])
		
		let params: [(q: String, o: NonEmptyOptions, a: NonEmptyOptions, e: BasicQuizBuilder.AddingError)] = [
			("q1", ["o3", "o4", "o5"], ["o1", "o3"], .duplicateQuestion(.multipleAnswer("q1"))),
			("q2", ["o3", "o3", "o5"], ["o1", "o3"], .duplicateOptions(["o3", "o3", "o5"])),
			("q2", ["o3", "o4", "o5"], ["o3", "o3", "o5"], .duplicateAnswers(["o3", "o3", "o5"])),
			("q2", ["o3", "o4", "o5"], ["o6"], .missingAnswerInOptions(answer: ["o6"], options: ["o3", "o4", "o5"]))
		]
		
		try params.forEach { (q, o, a, e) in
			assert(try sut.add(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
			assert(try sut.adding(multipleAnswerQuestion: q, options: o, answer: a), throws: e)
		}
	}
	
	// MARK: - Helpers
	
	private func assertEqual(_ a1: [(Question<String>, [String])], _ a2: [(Question<String>, [String])], file: StaticString = #file, line: UInt = #line) {
		XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
	}
	
	private func assert<T>(_ expression: @autoclosure () throws -> T, throws expectedError: BasicQuizBuilder.AddingError, file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertThrowsError(try expression()) { error in
			XCTAssertEqual(error as? BasicQuizBuilder.AddingError, expectedError, file: file, line: line)
		}
	}
	
}

extension NonEmptyOptions: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: String...) {
		self.init(elements[0], Array(elements.dropFirst()))
	}
}
