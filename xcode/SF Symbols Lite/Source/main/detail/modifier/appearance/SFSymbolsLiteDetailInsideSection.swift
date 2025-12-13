import SwiftUI

struct SFSymbolsLiteDetailInsideSection: ViewModifier {

	func body(content: Content) -> some View {
		content
			.background(RoundedRectangle(cornerRadius: 12).fill(.primary.opacity(0.02)))
			.overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.primary.opacity(0.04), lineWidth: 1))
	}
}

extension View {

	func detailInsideSection() -> some View {
		modifier(SFSymbolsLiteDetailInsideSection())
	}
}
