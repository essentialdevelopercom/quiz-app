//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class Quiz {
	private let flow: Any
	
	private init(flow: Any) {
		self.flow = flow
	}
	
    public static func start<Delegate: QuizDelegate, DataSource: QuizDataSource>(
		questions: [Delegate.Question],
		delegate: Delegate,
        dataSource: DataSource
	) -> Quiz where Delegate.Answer: Equatable {
		let flow = Flow(questions: questions, delegate: delegate, dataSource: dataSource)
		flow.start()
		return Quiz(flow: flow)
	}
}
