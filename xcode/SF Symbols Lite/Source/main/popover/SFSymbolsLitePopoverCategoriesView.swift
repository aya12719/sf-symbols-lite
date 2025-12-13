import SwiftUI

struct SFSymbolsLitePopoverCategoriesView: View {

	@Environment(\.dismiss) private var dismiss
	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@State private var symbol: String = "square.grid.2x2"
	@State private var glyph: String = "􀇷"
	@State private var label: String = ""
	@State private var showPopover: Bool = false
	@State private var symbolSearch: String = ""

	var selectedSymbol: Symbol?

	private var symbolsFiltered: [Symbol] {
		if symbolSearch.isEmpty {
			return symbols.sorted { $0.name < $1.name }
		}
		return symbols.filter { $0.name.localizedCaseInsensitiveContains(symbolSearch) && !$0.glyph.isEmpty }.sorted { $0.name < $1.name }
	}

	private func addCategory() {
		let category = SymbolCategory(name: label.replacingOccurrences(of: " ", with: ".").lowercased(), symbol: symbol, glyph: glyph, label: label, custom: true)
		categories.insert(category)
		if let selectedSymbol {
			selectedSymbol.categories.insert(category)
		}
		SymbolsData.shared.save(categories: categories, symbols: symbols)
	}

	var body: some View {
		VStack {
			HStack {
				TextField("Category Name", text: $label)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						if label.count > 0 {
							addCategory()
							dismiss()
						}
					}

				Button {
					showPopover.toggle()
				} label: {
					HStack(spacing: 4) {
						Image(systemName: symbol)
							.imageScale(.medium)
							.foregroundStyle(.primary)

						Image(systemName: "chevron.down")
							.font(.system(size: 10, weight: .semibold))
							.foregroundStyle(.secondary)
					}
				}
				.buttonStyle(.borderless)
				.popover(isPresented: $showPopover, arrowEdge: .bottom) {
					VStack {
						TextField("Search symbol", text: $symbolSearch)
							.textFieldStyle(.roundedBorder)

						ScrollView {
							LazyVStack(alignment: .leading, spacing: 6) {
								ForEach(symbolsFiltered, id: \.self) { item in
									HStack {
										Image(systemName: item.name)
											.frame(width: 20, height: 20)
										Text(item.name)
											.lineLimit(1)
										Spacer()
									}
									.contentShape(Rectangle())
									.onTapGesture {
										symbol = item.name
										glyph = item.glyph
										showPopover = false
									}
								}
							}
						}
						.frame(width: 500, height: 300)
					}
					.padding(20)
				}
			}

			HStack {
				Spacer()
				Button("Cancel") {
					dismiss()
				}
				Button("OK") {
					if label.count > 0 {
						addCategory()
						dismiss()
					}
				}
				.buttonStyle(.borderedProminent)
				.keyboardShortcut(.defaultAction)
				.disabled(label.isEmpty || symbol.isEmpty)
			}
		}
		.frame(width: 300)
		.padding(20)
	}
}
