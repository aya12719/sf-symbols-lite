import SwiftUI

struct SFSymbolsLiteDetailPlatformsView: View {

	@ObservedObject var symbol: Symbol

	@AppStorage("SFSymbolsLiteDetailPlatformsViewIsExpanded") private var isExpanded: Bool = false

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Button {
					isExpanded.toggle()
				} label: {
					Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 10, height: 10)
						.foregroundStyle(.secondary)
						.contentShape(Rectangle())
				}
				.buttonStyle(.plain)

				Text("PLATFORMS")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				SFSymbolsLiteDetailGridLayout(horizontalSpacing: 6, verticalSpacing: 6) {
					if let iOS = symbol.platform?.iOS {
						Text("􀟜 " + iOS)
							.tokenSection()
					}
					if let macOS = symbol.platform?.macOS {
						Text("􀙗 " + macOS)
							.tokenSection()
					}
					if let watchOS = symbol.platform?.watchOS {
						Text("􀟤 " + watchOS)
							.tokenSection()
					}
					if let tvOS = symbol.platform?.tvOS {
						Text("􀨫 " + tvOS)
							.tokenSection()
					}
					if let visionOS = symbol.platform?.visionOS {
						Text("􁎖 " + visionOS)
							.tokenSection()
					}
				}
			}
		}
	}
}
