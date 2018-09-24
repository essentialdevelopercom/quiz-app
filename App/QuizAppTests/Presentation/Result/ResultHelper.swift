//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

@testable import QuizEngine

extension Result {
	static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
		return Result(answers: answers, score: score)
	}
}

extension Result: Equatable where Answer: Equatable {
	public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
		return lhs.score == rhs.score && lhs.answers == rhs.answers
	}
}

extension Result: Hashable where Answer: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(answers)
		hasher.combine(score)
	}
}
