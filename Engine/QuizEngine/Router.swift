//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

class AnyRouter<Question: Hashable, Answer>: Router {
    let routeToQuestionImp: (Question, @escaping (Answer) -> Void) -> Void
    let routeToResultImp: (Result<Question, Answer>) -> Void
    
    public init<R: Router>(_ router: R) where R.Answer == Answer, R.Question == Question  {
        routeToQuestionImp = { router.routeTo(question: $0, answerCallback: $1) }
        routeToResultImp = { router.routeTo(result: $0) }
    }
    
    public func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void) {
        routeToQuestionImp(question, answerCallback)
    }
    
    public func routeTo(result: Result<Question, Answer>) {
        routeToResultImp(result)
    }
}
