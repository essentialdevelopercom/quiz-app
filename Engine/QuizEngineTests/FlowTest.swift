//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
	
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(dataSource.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }

    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(dataSource.questionsAsked, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(dataSource.questionsAsked, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")

        XCTAssertEqual(dataSource.questionsAsked, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        
        XCTAssertEqual(dataSource.questionsAsked, ["Q1"])
    }
	
	func test_start_withOneQuestion_doesNotCompleteQuiz() {
		makeSUT(questions: ["Q1"]).start()
		
		XCTAssertTrue(delegate.completedQuizzes.isEmpty)
	}

    func test_start_withNoQuestions_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
		XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
	
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        
		XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        dataSource.answerCompletions[0]("A1")
        dataSource.answerCompletions[1]("A2")
		
		XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
	
	func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestions_completesQuizTwice() {
		let sut = makeSUT(questions: ["Q1", "Q2"])
		sut.start()

		dataSource.answerCompletions[0]("A1")
		dataSource.answerCompletions[1]("A2")

		dataSource.answerCompletions[0]("A1-1")
		dataSource.answerCompletions[1]("A2-2")
		
		XCTAssertEqual(delegate.completedQuizzes.count, 2)
		assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
		assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
	}
	
    // MARK: Helpers
	
	private let delegate = DelegateSpy()
    private let dataSource = DataSourceSpy()
	
	private weak var weakSUT: Flow<DelegateSpy, DataSourceSpy>?
	
	override func tearDown() {
		super.tearDown()
		
		XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
	}
	
    private func makeSUT(questions: [String]) -> Flow<DelegateSpy, DataSourceSpy> {
        let sut = Flow(questions: questions, delegate: delegate, dataSource: dataSource)
		weakSUT = sut
		return sut
    }

}
