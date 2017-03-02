//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {

    let options = ["A1", "A2"]

    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: Question.singleAnswer("Q1")).question, "Q1")
    }
 
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: Question.singleAnswer("Q1")).options, options)
    }

    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: Question.singleAnswer("Q1"))
        _ = controller.view
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: Question.multipleAnswer("Q1")).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: Question.multipleAnswer("Q1")).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: Question.multipleAnswer("Q1"))
        _ = controller.view
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }

    // MARK: Helpers
    
    func makeSUT(options: Dictionary<Question<String>, [String]>) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: {_ in }) as! QuestionViewController
    }
}
