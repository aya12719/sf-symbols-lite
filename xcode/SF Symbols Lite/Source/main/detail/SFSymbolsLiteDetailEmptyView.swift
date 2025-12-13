import SwiftUI

struct SFSymbolsLiteDetailEmptyView: View {

	var body: some View {
		List {}
			.disabled(true)
			.opacity(0)
		Text("No Selection")
			.font(.largeTitle)
			.foregroundStyle(.secondary)
	}
}
