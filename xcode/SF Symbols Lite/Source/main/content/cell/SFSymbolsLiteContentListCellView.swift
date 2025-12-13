import SwiftUI

struct SFSymbolsLiteContentListCellView: View {

	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol

	var body: some View {
		HStack {
			ZStack {
				Image(systemName: symbol.name)
					.resizable()
					.scaledToFit()
					.frame(height: 16)
					.foregroundStyle(.primary)
			}
			.frame(width: 20, alignment: .center)
			.padding(.vertical, 5)
			.padding(.leading, 5)

			Text(symbol.name)
			Spacer()

			Button {
				symbol.favorite.toggle()
				SymbolsData.shared.save(symbols: symbols)
			} label: {
				Image(systemName: symbol.favorite ? "heart.fill" : "heart")
			}
			.buttonStyle(.plain)
			.padding(.trailing, 5)
		}
		.listRowSeparator(.hidden)
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
	}
}
