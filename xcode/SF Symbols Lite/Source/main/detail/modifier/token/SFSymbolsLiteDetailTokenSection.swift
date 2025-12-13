import SwiftUI

struct SFSymbolsLiteDetailTokenSection: ViewModifier {

	var selected: Bool
	var color: Color = .primary
	var font: Font = .body
	var padding: CGFloat = 6

	func body(content: Content) -> some View {
		content
			.font(font)
			.fontWeight(.regular)
			.foregroundStyle(selected ? .white : color)
			.padding(padding)
			.background(
				RoundedRectangle(cornerRadius: 8)
					.fill(selected ? Color.accentColor : Color(.textBackgroundColor))
					.fill(selected ? Color.accentColor : Color.primary.opacity(0.05))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.strokeBorder(
						Color.primary.opacity(0.1), lineWidth: 1)
			)
	}
}

extension View {

	func tokenSection(selected: Bool = false, color: Color = .primary, font: Font = .body, padding: CGFloat = 6) -> some View {
		modifier(SFSymbolsLiteDetailTokenSection(selected: selected, color: color, font: font, padding: padding))
	}
}
