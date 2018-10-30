//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {
	
    func test_title_returnsFormattedTitle() {
        XCTAssertEqual(makeSUT().title, "Result")
    }
    
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2", "A3"])]
		let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2"])]
		
		let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 1)
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let sut = makeSUT(userAnswers: [], correctAnswers: [])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"])]
		
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }

    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let userAnswers = [(multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(multipleAnswerQuestion, ["A2", "A3"])]
		
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }

    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let userAnswers = [(singleAnswerQuestion, ["A2"]), (multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"]), (multipleAnswerQuestion, ["A1", "A4"])]
		
		let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
		
        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }

	// MARK: - Helpers
	
	private let singleAnswerQuestion = Question.singleAnswer("Q1")
	private let multipleAnswerQuestion = Question.multipleAnswer("Q2")

	private func makeSUT(
		userAnswers: ResultsPresenter.Answers = [],
		correctAnswers: ResultsPresenter.Answers = [],
		score: Int = 0
	) -> ResultsPresenter {
		return ResultsPresenter(
			userAnswers: userAnswers,
			correctAnswers: correctAnswers,
			scorer: { _, _ in score })
	}
}
