//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public class Game <R: Router> {
    let flow: Flow<R>
    
    init(flow: Flow<R>) {
        self.flow = flow
    }
}

public func startGame<R: Router>(questions: [R.Question], router: R, correctAnswers: [R.Question: R.Answer]) -> Game<R> where R.Answer: Equatable{
    let flow = Flow(questions: questions, router: router, scoring: { scoring($0, correctAnswers: correctAnswers) })
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
