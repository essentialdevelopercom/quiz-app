//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question
    associatedtype Answer

    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
