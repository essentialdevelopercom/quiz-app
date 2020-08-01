//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDataSource {
    associatedtype Question
    associatedtype Answer

	func answer(for question: Question, completion: @escaping (Answer) -> Void)
}

public protocol QuizDelegate {
    associatedtype Question
    associatedtype Answer

    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
