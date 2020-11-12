//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import SwiftUI

struct RoundedButton: View {
	let title: String
	let isEnabled: Bool
	let action: () -> Void
	
	init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
		self.title = title
		self.isEnabled = isEnabled
		self.action = action
	}
	
	var body: some View {
		Button(action: action, label: {
			HStack {
				Spacer()
				Text(title)
					.padding()
					.foregroundColor(Color.white)
				Spacer()
			}
			.background(Color.blue)
			.cornerRadius(25)
		})
		.buttonStyle(PlainButtonStyle())
		.disabled(!isEnabled)
	}
}

struct RoundedButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RoundedButton(title: "Enabled", isEnabled: true, action: {})
				.previewLayout(.sizeThatFits)
			
			RoundedButton(title: "Disabled", isEnabled: false, action: {})
				.previewLayout(.sizeThatFits)
		}
	}
}
