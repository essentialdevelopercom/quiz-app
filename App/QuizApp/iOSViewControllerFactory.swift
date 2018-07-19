//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {

    private let questions: [Question<String>]
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Dictionary<Question<String>, [String]>
    
    init(questions: [Question<String>], options: Dictionary<Question<String>, [String]>, correctAnswers: Dictionary<Question<String>, [String]>) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
            
        case .multipleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }

    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
		let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
		controller.title = presenter.title
		return controller
    }
}
