//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let answers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: answers, score: 1)
        
        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let answers = Dictionary<Question<String>, [String]>()
        let result = Result(answers: answers, score: 0)

        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: ["A2"]]
        let result = Result(answers: answers, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }

    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers = [multipleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers = [multipleAnswerQuestion: ["A2", "A3"]]
        let result = Result(answers: answers, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: [multipleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }

    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let answers = [multipleAnswerQuestion: ["A1", "A4"], singleAnswerQuestion: ["A2"]]
        let correctAnswers = [multipleAnswerQuestion: ["A1", "A4"], singleAnswerQuestion: ["A2"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: answers, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }

}
