//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI
import XCTest
import QuizEngine
@testable import QuizApp

class iOSSwiftUINavigationAdapterTest: XCTestCase {
	
	func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
		let presenter = QuestionPresenter(questions: questions, question: singleAnswerQuestion)
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		
		XCTAssertEqual(view.title, presenter.title)
	}
	
	func test_questionViewController_singleAnswer_createsControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		
		XCTAssertEqual(view.question, "Q1")
	}
	
	func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		
		XCTAssertEqual(view.options, options[singleAnswerQuestion])
	}
	
	func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
		var answers = [[String]]()
		let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))
		
		XCTAssertEqual(answers, [])
		
		view.selection(view.options[0])
		XCTAssertEqual(answers, [[view.options[0]]])
		
		view.selection(view.options[1])
		XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
	}
	
	func test_questionViewController_multipleAnswer_createsControllerWithTitle() throws {
		let presenter = QuestionPresenter(questions: questions, question: multipleAnswerQuestion)
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		
		XCTAssertEqual(view.title, presenter.title)
	}
	
	func test_questionViewController_multipleAnswer_createsControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		
		XCTAssertEqual(view.question, "Q2")
	}
	
	func test_questionViewController_multipleAnswer_createsControllerWithOptions() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestion())
		
		XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
	}
	
	func test_resultsViewController_createsControllerWithTitle() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		
		XCTAssertEqual(view.title, presenter.title)
	}
	
	func test_resultsViewController_createsControllerWithSummary() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		
		XCTAssertEqual(view.summary, presenter.summary)
	}
	
	func test_resultsViewController_createsControllerWithPresentableAnswers() throws {
		let (view, presenter) = try XCTUnwrap(makeResults())
		
		XCTAssertEqual(view.answers, presenter.presentableAnswers)
	}
	
	func test_resultsViewController_createsControllerWithPlayAgainAction() throws {
		var playAgainCount = 0
		let (view, _) = try XCTUnwrap(makeResults(playAgain: { playAgainCount += 1 }))
		
		XCTAssertEqual(playAgainCount, 0)
		
		view.playAgain()
		XCTAssertEqual(playAgainCount, 1)
		
		view.playAgain()
		XCTAssertEqual(playAgainCount, 2)
	}
	
	func test_answerForQuestion_replacesCurrentView() {
		let (sut, navigation) = makeSUT()
		
		sut.answer(for: singleAnswerQuestion) { _ in }
		XCTAssertNotNil(navigation.singleCurrentView)
		
		sut.answer(for: multipleAnswerQuestion) { _ in }
		XCTAssertNotNil(navigation.multipleCurrentView)
	}
	
	func test_didCompleteQuiz_replacesCurrentView() {
		let (sut, navigation) = makeSUT()
		
		sut.didCompleteQuiz(withAnswers: correctAnswers)
		XCTAssertNotNil(navigation.resultCurrentView)
		
		sut.didCompleteQuiz(withAnswers: correctAnswers)
		XCTAssertNotNil(navigation.resultCurrentView)
	}
	
	// MARK: Helpers
	
	private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
	
	private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
	
	private var questions: [Question<String>] {
		[singleAnswerQuestion, multipleAnswerQuestion]
	}
	
	private var options: [Question<String>: [String]] {
		[singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
	}
	
	private var correctAnswers: [(Question<String>, [String])] {
		[(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4", "A5"])]
	}
	
	private class NonAnimatedNavigationController: UINavigationController {
		override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
			super.setViewControllers(viewControllers, animated: false)
		}
		
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			super.pushViewController(viewController, animated: false)
		}
	}
	
	private func makeSUT(playAgain: @escaping () -> Void = {}) -> (iOSSwiftUINavigationAdapter, NonAnimatedNavigationController) {
		let navigation = NonAnimatedNavigationController()
		let sut = iOSSwiftUINavigationAdapter(navigation: navigation, options: options, correctAnswers: correctAnswers, playAgain: playAgain)
		return (sut, navigation)
	}
	
	private func makeSingleAnswerQuestion(
		answerCallback: @escaping ([String]) -> Void = { _ in }
	) -> SingleAnswerQuestion? {
		let (sut, navigation) = makeSUT()
		sut.answer(for: singleAnswerQuestion, completion: answerCallback)
		return navigation.singleCurrentView
	}
	
	private func makeMultipleAnswerQuestion(
		answerCallback: @escaping ([String]) -> Void = { _ in }
	) -> MultipleAnswerQuestion? {
		let (sut, navigation) = makeSUT()
		sut.answer(for: multipleAnswerQuestion, completion: answerCallback)
		return navigation.multipleCurrentView
	}
	
	private func makeResults(playAgain: @escaping () -> Void = {}) -> (view: ResultView, presenter: ResultsPresenter)? {
		let (sut, navigation) = makeSUT(playAgain: playAgain)
		sut.didCompleteQuiz(withAnswers: correctAnswers)
		
		let view = navigation.resultCurrentView
		let presenter = ResultsPresenter(
			userAnswers: correctAnswers,
			correctAnswers: correctAnswers,
			scorer: BasicScore.score
		)
		return view.map { ($0, presenter) }
	}
}

private extension UINavigationController {
	var singleCurrentView: SingleAnswerQuestion? {
		(topViewController as? UIHostingController<SingleAnswerQuestion>)?.rootView
	}
	
	var multipleCurrentView: MultipleAnswerQuestion? {
		(topViewController as? UIHostingController<MultipleAnswerQuestion>)?.rootView
	}
	
	var resultCurrentView: ResultView? {
		(topViewController as? UIHostingController<ResultView>)?.rootView
	}
}
