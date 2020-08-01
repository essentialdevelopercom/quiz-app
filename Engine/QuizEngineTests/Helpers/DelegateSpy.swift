//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
	var completedQuizzes: [[(String, String)]] = []
	
	func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
		completedQuizzes.append(answers)
	}
}

class DataSourceSpy: QuizDataSource {
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []

    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
}
