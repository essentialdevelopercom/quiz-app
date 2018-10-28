//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class Quiz {
	private let flow: Any
	
	private init(flow: Any) {
		self.flow = flow
	}
	
	public static func start<Delegate: QuizDelegate>(
		questions: [Delegate.Question],
		delegate: Delegate
	) -> Quiz where Delegate.Answer: Equatable {
		let flow = Flow(
			questions: questions,
			delegate: delegate
		)
		flow.start()
		return Quiz(flow: flow)
	}
}

func scoring<Question, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
	return answers.reduce(0) { (score, tuple) in
		return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
	}
}
