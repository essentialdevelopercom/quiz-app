//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
	typealias Answers = [(question: Question<String>, answers: [String])]
	
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
	
	func resultsViewController(for userAnswers: Answers) -> UIViewController

    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
