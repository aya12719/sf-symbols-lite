import SwiftUI

struct SFSymbolsLiteDetailSection: ViewModifier {

	func body(content: Content) -> some View {
		content
			.padding(10)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(RoundedRectangle(cornerRadius: 12).fill(.primary.opacity(0.02)))
			.overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.primary.opacity(0.04), lineWidth: 1))
			.listRowSeparator(.hidden)
	}
}

extension View {

	func detailSection() -> some View {
		modifier(SFSymbolsLiteDetailSection())
	}
}
