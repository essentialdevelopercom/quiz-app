//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
	
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCompletion("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
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
        
        delegate.answerCompletion("A1")
        
		XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_delegatesResultHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in 10 })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
            receivedAnswers = answers
            return 20
        })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }


    // MARK: Helpers
	
	private let delegate = DelegateSpy()
	
	private weak var weakSUT: Flow<DelegateSpy>?
	
	override func tearDown() {
		super.tearDown()
		
		XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
	}
	
    private func makeSUT(questions: [String],
                 scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate, scoring: scoring)
		weakSUT = sut
		return sut
    }
	
	private class DelegateSpy: QuizDelegate {
		var handledQuestions: [String] = []
		var handledResult: Result<String, String>? = nil
		var completedQuizzes: [[(String, String)]] = []
		
		var answerCompletion: (String) -> Void = { _ in }
		
		func answer(for question: String, completion: @escaping (String) -> Void) {
			handledQuestions.append(question)
			self.answerCompletion = completion
		}
		
		func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
			completedQuizzes.append(answers)
		}
		
		func handle(result: Result<String, String>) {
			handledResult = result
		}
	}

}
