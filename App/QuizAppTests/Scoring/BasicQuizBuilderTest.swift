//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest

struct BasicQuiz {
	
}

struct BasicQuizBuilder {
	func build() -> BasicQuiz? {
		nil
	}
}

class BasicQuizBuilderTest: XCTestCase {

    func test_empty() {
        let sut = BasicQuizBuilder()
		
		XCTAssertNil(sut.build())
    }

}
