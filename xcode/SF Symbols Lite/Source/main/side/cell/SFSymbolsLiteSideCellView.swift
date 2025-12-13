import SwiftUI

struct SFSymbolsLiteSideCellView: View {

	@Binding var selectedCategory: SymbolCategory?
	var category: SymbolCategory

	var body: some View {
		HStack(alignment: .center, spacing: 8) {
			ZStack {
				Image(systemName: category.symbol)
					.resizable()
					.scaledToFit()
					.frame(height: 16)
					.foregroundStyle(.primary)
			}
			.frame(width: 20, alignment: .center)

			Text(category.label)
				.font(.body)
				.foregroundStyle(.primary)

			Spacer()
		}
		.contentShape(Rectangle())
		.onTapGesture {
			selectedCategory = category
		}
	}
}
