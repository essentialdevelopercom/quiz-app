//	
// Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

final class BasicScore {
	static func score<T: Equatable>(for answers: [T], comparingTo correctAnswers: [T]) -> Int {
		return zip(answers, correctAnswers).reduce(0) { score, tuple in
			return score + (tuple.0 == tuple.1 ? 1 : 0)
		}
	}
}
