//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    
    init(options: [String]) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    
    mutating func select() {
        isSelected.toggle()
    }
}

class MultipleSelectionStoreTests: XCTestCase {

    func test_selectOption_togglesState() {
        var sut = MultipleSelectionStore(options: ["o0", "o1"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }

}
