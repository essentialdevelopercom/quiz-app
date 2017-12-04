//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public class Game <Question: Hashable, Answer: Equatable> {
    private let questions: [Question]
    private let correctAnswers: [Question: Answer]
    private let router: AnyRouter<Question, Answer>
    
    private var flow: Flow<Question, Answer>?
    
    public init <R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {
        self.questions = questions
        self.correctAnswers = correctAnswers
        self.router = AnyRouter(router)
    }
    
    public func start() {
        flow = makeFlow()
        flow?.start()
    }
    
    private func makeFlow() -> Flow<Question, Answer> {
        return Flow(questions: questions, router: router, scoring: scoring(with: correctAnswers))
    }
    
    private func scoring(with correctAnswers: [Question: Answer]) -> (_ answers: [Question: Answer]) -> Int {
        return { answers in
            answers.reduce(0) { (score, tuple) in score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)}
        }
    }
}


