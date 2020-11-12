//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI
import UIKit
import QuizEngine

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Answers
    private let playAgain: () -> Void
	
    private var questions: [Question<String>] {
        return correctAnswers.map { $0.question }
    }
    
	init(options: Dictionary<Question<String>, [String]>, correctAnswers: Answers, playAgain: @escaping () -> Void = {}) {
        self.options = options
        self.correctAnswers = correctAnswers
		self.playAgain = playAgain
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        switch question {
        case .singleAnswer(let value):
            return UIHostingController(
                rootView: SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { answerCallback([$0]) }))
            
        case .multipleAnswer(let value):
            return UIHostingController(
                rootView: MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: answerCallback)))
        }
    }
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )

		return UIHostingController(
			rootView: ResultView(
				title: presenter.title,
				summary: presenter.summary,
				answers: presenter.presentableAnswers,
				playAgain: playAgain))
    }
}
