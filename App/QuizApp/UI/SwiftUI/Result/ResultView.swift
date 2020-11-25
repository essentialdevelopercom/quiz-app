//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	let title: String
	let summary: String
	let answers: [PresentableAnswer]
	let playAgain: () -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			HeaderView(title: title, subtitle: summary)
			
			List(answers, id: \.question) { model in
				ResultAnswerCell(model: model)
			}
			
			Spacer()
			
			RoundedButton(title: "Play again", action: playAgain)
				.padding()
		}
	}
}

struct ResultView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ResultTestView()
			
			ResultTestView()
				.preferredColorScheme(.dark)
				.environment(\.sizeCategory, .extraExtraExtraLarge)
		}
	}
	
	struct ResultTestView: View {
		@State var playAgainCount = 0
		
		var body: some View {
			VStack {
				ResultView(
					title: "Result",
					summary: "You got 2/5 correct",
					answers: [
						.init(question: "What's the answer to question #001?", answer: "A correct answer", wrongAnswer: "A wrong answer"),
						.init(question: "What's the answer to question #002?", answer: "A correct answer", wrongAnswer: nil),
						.init(question: "What's the answer to question #003?", answer: "A correct answer", wrongAnswer: "A wrong answer"),
						.init(question: "What's the answer to question #004?", answer: "A correct answer", wrongAnswer: nil),
						.init(question: "What's the answer to question #005?", answer: "A correct answer", wrongAnswer: "A wrong answer"),
					],
					playAgain: { playAgainCount += 1 })
				
				Text("Play again count: \(playAgainCount)")
			}
		}
	}
}
