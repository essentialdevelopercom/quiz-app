//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

struct SingleTextSelectionCell: View {
    let text: String
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection, label: {
            HStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: 2.5)
                    .frame(width: 40.0, height: 40.0)
                
                Text(text)
                    .font(.title)
                    .foregroundColor(Color.secondary)
                
                Spacer()
            }.padding()
        })
    }
}

struct SingleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        SingleTextSelectionCell(text: "A text", selection: {})
            .previewLayout(.sizeThatFits)
    }
}
