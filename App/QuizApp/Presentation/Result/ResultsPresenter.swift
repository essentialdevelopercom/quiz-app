//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    let result: Result<Question<String>, Set<String>>
    let questions: [Question<String>]
    let options: Dictionary<Question<String>, [String]>
    let correctAnswers: Dictionary<Question<String>, Set<String>>
    
    var title: String {
        return "Result"
    }
    
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = result.answers[question],
                let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            
            return presentableAnswer(question, userAnswer, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswer: Set<String>, _ correctAnswer: Set<String>) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(ordered(correctAnswer, for: question)),
                wrongAnswer: formattedWrongAnswer(ordered(userAnswer, for: question), ordered(correctAnswer, for: question)))
        }
    }
    
    private func ordered(_ answers: Set<String>, for question: Question<String>) -> [String] {
        guard let options = options[question] else { return [] }
        
        return options.filter { answers.contains($0) }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }

    private func formattedWrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
        return correctAnswer == userAnswer ? nil : formattedAnswer(userAnswer)
    }
}
