//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class QuestionPresenterTest: XCTestCase {
    
    let question1 = Question.singleAnswer("A1")
    let question2 = Question.multipleAnswer("A2")

    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        
        XCTAssertEqual(sut.title, "Question #1")
    }
 
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "Question #2")
    }

    func test_title_forUnexistentQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("A1"))
        
        XCTAssertEqual(sut.title, "")
    }

}
