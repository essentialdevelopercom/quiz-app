//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "use QuizDelegate instead")
public protocol Router {
	associatedtype Question: Hashable
	associatedtype Answer
	
	func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
	func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public struct Result<Question: Hashable, Answer> {
	public let answers: [Question: Answer]
	public let score: Int
}

@available(*, deprecated, message: "use Quiz instead")
public class Game <Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated, message: "use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router, correctAnswers))
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated, message: "remove along with the deprecated Game types")
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
	private let router: R
	private let correctAnswers: [R.Question: R.Answer]
	
	init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
		self.router = router
		self.correctAnswers = correctAnswers
	}
	
	func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
		router.routeTo(question: question, answerCallback: completion)
	}
	
	func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
		let answersDictionary = answers.reduce([R.Question: R.Answer]()) { acc, tuple in
			var acc = acc
			acc[tuple.question] = tuple.answer
			return acc
		}
		let score = scoring(answersDictionary, correctAnswers: correctAnswers)
		let result = Result(answers: answersDictionary, score: score)
		router.routeTo(result: result)
	}
	
	private func scoring(_ answers: [R.Question: R.Answer], correctAnswers: [R.Question: R.Answer]) -> Int {
		return answers.reduce(0) { (score, tuple) in
			return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
		}
	}
}
