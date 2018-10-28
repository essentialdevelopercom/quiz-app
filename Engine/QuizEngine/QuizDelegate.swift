//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer
	
	func answer(for question: Question, completion: @escaping (Answer) -> Void)
	
	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])

	@available(*, deprecated, message: "use didCompleteQuiz(withAnswers:) instead")
	func handle(result: Result<Question, Answer>)
}

public extension QuizDelegate {
	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {}
}
