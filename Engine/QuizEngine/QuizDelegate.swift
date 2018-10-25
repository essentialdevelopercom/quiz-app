//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer
	
	func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
	func handle(result: Result<Question, Answer>)
}
