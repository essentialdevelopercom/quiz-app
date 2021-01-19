//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit
import BasicQuizDomain

protocol ViewControllerFactory {
	typealias Answers = [(question: Question<String>, answer: [String])]
	
	func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
	
	func resultsViewController(for userAnswers: Answers) -> UIViewController
}
