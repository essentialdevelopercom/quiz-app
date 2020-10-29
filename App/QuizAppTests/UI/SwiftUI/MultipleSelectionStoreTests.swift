//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
@testable import QuizApp

class MultipleSelectionStoreTests: XCTestCase {

    func test_toggleSelection_togglesOptionSelectionState() {
        var sut = makeSUT(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].toggleSelection()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].toggleSelection()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = makeSUT(options: ["o0", "o1"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].toggleSelection()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].toggleSelection()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].toggleSelection()
        XCTAssertTrue(sut.canSubmit)
    }
    
    func test_submit_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = makeSUT(options: ["o0", "o1"], handler: {
            submittedOptions.append($0)
        })
        
        sut.submit()
        XCTAssertEqual(submittedOptions, [])

        sut.options[0].toggleSelection()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"]])
        
        sut.options[1].toggleSelection()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"], ["o0", "o1"]])
    }

    // MARK: - Helpers
    
    private func makeSUT(options: [String], handler: @escaping ([String]) -> Void = { _ in }) -> MultipleSelectionStore {
        return MultipleSelectionStore(options: options, handler: handler)
    }
}
