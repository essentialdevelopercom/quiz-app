//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
	
	private var quiz: Quiz?
	
	func test_startQuiz_answersAllQuestions_completesWithAnswers() {
		let (delegate, dataSource) = makeSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, dataSource: dataSource)

		dataSource.answerCompletions[0]("A1")
		dataSource.answerCompletions[1]("A2")
		
		XCTAssertEqual(delegate.completedQuizzes.count, 1)
		assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
	}
	
	func test_startQuiz_answersAllQuestionsTwice_completesWithNewAnswers() {
		let (delegate, dataSource) = makeSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, dataSource: dataSource)

		dataSource.answerCompletions[0]("A1")
		dataSource.answerCompletions[1]("A2")

		dataSource.answerCompletions[0]("A1-1")
		dataSource.answerCompletions[1]("A2-2")

		XCTAssertEqual(delegate.completedQuizzes.count, 2)
		assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
		assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
	}

    // MARK: Helpers

    private func makeSpy() -> (delegate: DelegateSpy, dataSource: DataSourceSpy) {
        (DelegateSpy(), DataSourceSpy())
    }
}
