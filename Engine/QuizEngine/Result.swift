//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import Foundation

struct Result<Question: Hashable, Answer> {
    let answers: [Question: Answer]
    let score: Int
}
