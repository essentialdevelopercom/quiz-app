//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public func startGame<Question: Hashable, Answer, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {
    
}
