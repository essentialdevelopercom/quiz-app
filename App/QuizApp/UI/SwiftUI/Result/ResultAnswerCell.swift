//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

struct ResultAnswerCell: View {
	let model: PresentableAnswer
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			Text(model.question)
				.font(.title)
			
			Text(model.answer)
				.font(.title2)
				.foregroundColor(.green)
			
			if let wrongAnswer = model.wrongAnswer {
				Text(wrongAnswer)
					.font(.title2)
					.foregroundColor(.red)
			}
		}.padding(.vertical)
	}
}

struct ResultAnswerCell_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ResultAnswerCell(model: .init(question: "A question", answer: "A correct answer", wrongAnswer: "A wrong answer"))
				.previewLayout(.sizeThatFits)
			
			ResultAnswerCell(model: .init(question: "A question", answer: "A correct answer", wrongAnswer: nil))
				.previewLayout(.sizeThatFits)
		}
	}
}
