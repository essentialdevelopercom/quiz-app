//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer
	
	func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
	func handle(result: Result<Question, Answer>)
}

@available(*, deprecated)
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
