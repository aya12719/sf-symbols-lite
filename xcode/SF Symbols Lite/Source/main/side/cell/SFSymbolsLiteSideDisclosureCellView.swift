import SwiftUI

struct SFSymbolsLiteSideDisclosureCellView: View {

	var image: String
	var label: String

	var body: some View {

		HStack(alignment: .center, spacing: 8) {
			ZStack {
				Image(systemName: image)
					.resizable()
					.scaledToFit()
					.frame(height: 16)
					.foregroundStyle(.primary)
			}
			.frame(width: 20, alignment: .center)

			Text(label)
				.font(.body)
				.foregroundStyle(.primary)

			Spacer()
		}
	}
}
