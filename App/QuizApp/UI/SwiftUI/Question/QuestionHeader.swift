//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

struct QuestionHeader: View {
    let title: String
    let question: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color.blue)
                .padding(.top)
            
            Text(question)
                .font(.largeTitle)
                .fontWeight(.medium)
        }.padding()
    }
}

struct QuestionHeader_Previews: PreviewProvider {
    static var previews: some View {
        QuestionHeader(title: "A title", question: "A question")
            .previewLayout(.sizeThatFits)
    }
}
