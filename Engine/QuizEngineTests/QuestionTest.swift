//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class QuestionTest: XCTestCase {

    func test_hashValue_singleAnswer_returnsTypeHash() {
        let type = "a string"
        
        let sut = Question.singleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let type = "a string"
        
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }

}
