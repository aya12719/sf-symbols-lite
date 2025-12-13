import SwiftUI

struct SFSymbolsLiteContentGridCellView: View {

	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@Binding var selectedSymbol: Symbol?
	@ObservedObject var symbol: Symbol

	var body: some View {
		VStack(alignment: .center, spacing: 8) {
			ZStack(alignment: .bottomTrailing) {
				VStack {
					Image(systemName: symbol.name)
						.font(.system(size: 40))
						.foregroundStyle(selectedSymbol == symbol ? .white : .primary)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				}
				.frame(height: 80)
				.background(
					RoundedRectangle(cornerRadius: 8)
						.fill(selectedSymbol == symbol ? Color.accentColor : Color.clear)
				)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
				)

				Button {
					symbol.favorite.toggle()
					SymbolsData.shared.save(symbols: symbols)
				} label: {
					Image(systemName: symbol.favorite ? "heart.fill" : "heart")
						.font(.body)
						.foregroundStyle(selectedSymbol == symbol ? .white : .primary)
				}

				.buttonStyle(.plain)
				.offset(x: -6, y: -6)
			}
			Text(symbol.name.replacingOccurrences(of: ".", with: ".\u{200B}"))
				.font(.body)
				.multilineTextAlignment(.center)
				.lineLimit(2)
				.truncationMode(.tail)
				.frame(maxWidth: .infinity)
				.foregroundStyle(selectedSymbol == symbol ? Color.accentColor : .primary)
		}
		.frame(width: 100, height: 120, alignment: .top)
		.contentShape(.rect)
		.draggable(TransferableSymbol(id: symbol.id, name: symbol.name, glyph: symbol.glyph))
		.onDrop(
			of: [.transferableCategory, .transferableTag, .transferableTerm],
			delegate: TransferableDelegate(
				types: [.transferableCategory, .transferableTag, .transferableTerm],
				onDropCategory: { id in
					if let first = categories.first(where: { $0.id == id }) {
						Task { @MainActor in
							symbol.categories.insert(first)
							SymbolsData.shared.save(symbols: symbols)
						}
					}
				},
				onDropTag: { id in
					if let first = Set(symbols.flatMap { $0.tags }).first(where: { $0.id == id }) {
						Task { @MainActor in
							symbol.tags.insert(first)
							SymbolsData.shared.save(symbols: symbols)
						}
					}
				},
				onDropTerm: { id in
					if let first = Set(symbols.flatMap { $0.terms }).first(where: { $0.id == id }) {
						Task { @MainActor in
							symbol.terms.insert(first)
							SymbolsData.shared.save(symbols: symbols)
						}
					}
				}
			)
		)
		.contextMenu {
			if !symbol.glyph.isEmpty {
				SFSymbolsLiteContextContentView(symbols: $symbols, symbol: symbol)
			}
		}
		.onTapGesture {
			if selectedSymbol == symbol && NSEvent.modifierFlags.contains(.command) {
				selectedSymbol = nil
			} else {
				selectedSymbol = symbol
			}
		}
	}
}
