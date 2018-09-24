//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

public enum Question<T: Hashable> : Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    public var hashValue: Int {
        switch self {
        case .singleAnswer(let value):
            return "singleAnswer".hashValue ^ value.hashValue
        case .multipleAnswer(let value):
            return "multipleAnswer".hashValue ^ value.hashValue
        }
    }
}
