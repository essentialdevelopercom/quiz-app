//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

class QuizNavigationStore: ObservableObject {
	enum CurrentView {
		case single(SingleAnswerQuestion)
		case multiple(MultipleAnswerQuestion)
		case result(ResultView)
	}
	
	@Published var currentView: CurrentView?
	
	var view: AnyView {
		switch currentView {
		case let .single(view): return AnyView(view)
		case let .multiple(view): return AnyView(view)
		case let .result(view): return AnyView(view)
		case .none: return AnyView(EmptyView())
		}
	}
}

struct QuizNavigationView: View {
	@ObservedObject var store: QuizNavigationStore
	
	var body: some View {
		store.view
			.transition(
				AnyTransition
					.opacity
					.combined(with: .move(edge: .trailing))
			)
			.id(UUID())
	}
}

struct QuizNavigationView_Previews: PreviewProvider {
	static var previews: some View {
		QuizNavigationView(store: QuizNavigationStore())
	}
}
