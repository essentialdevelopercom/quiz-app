//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import QuizEngine

public struct BasicQuiz {
	public let questions: [Question<String>]
	public let options: [Question<String>: [String]]
	public let correctAnswers: [(Question<String>, [String])]
}

public struct NonEmptyOptions {
	private let head: String
	private let tail: [String]
	
	public init(_ head: String, _ tail: String...) {
		self.head = head
		self.tail = tail
	}
	
	public init(_ head: String, _ tail: [String]) {
		self.head = head
		self.tail = tail
	}
	
	var all: [String] {
		[head] + tail
	}
}

public struct BasicQuizBuilder {
	private var questions: [Question<String>] = []
	private var options: [Question<String>: [String]] = [:]
	private var correctAnswers: [(Question<String>, [String])] = []
	
	public enum AddingError: Equatable, Error {
		case duplicateQuestion(Question<String>)
		case duplicateOptions([String])
		case duplicateAnswers([String])
		case missingAnswerInOptions(answer: [String], options: [String])
	}
	
	private init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [(Question<String>, [String])]) {
		self.questions = questions
		self.options = options
		self.correctAnswers = correctAnswers
	}
	
	public init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	public init(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
	
	public mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
		self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
	}
	
	public mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
		self = try adding(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
	}
	
	public func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
		try adding(
			question: Question.singleAnswer(singleAnswerQuestion),
			options: options.all,
			answer: [answer]
		)
	}
	
	public func adding(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws -> BasicQuizBuilder {
		try adding(
			question: Question.multipleAnswer(multipleAnswerQuestion),
			options: options.all,
			answer: answer.all
		)
	}
	
	public func build() -> BasicQuiz {
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
