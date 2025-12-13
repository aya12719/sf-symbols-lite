import SwiftUI
import UniformTypeIdentifiers

struct SFSymbolsLiteSideView: View {

	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@Binding var selectedCategory: SymbolCategory?
	@Binding var selectedSymbol: Symbol?
	@State private var systemExpanded: Bool = true
	@State private var customExpanded: Bool = false

	private var categoriesSorted: [SymbolCategory] {
		categories.sorted {
			if $0.name.lowercased() == "all" { return true }
			if $1.name.lowercased() == "all" { return false }
			return $0.name.localizedCompare($1.name) == .orderedAscending
		}
	}

	var body: some View {
		VStack {
			List(selection: $selectedCategory) {
				DisclosureGroup(isExpanded: $systemExpanded) {
					ForEach(categoriesSorted.filter { !$0.custom }, id: \.self) { category in
						SFSymbolsLiteSideCellView(selectedCategory: $selectedCategory, category: category)
					}
				} label: {
					SFSymbolsLiteSideDisclosureCellView(image: "folder", label: "System")
				}

				DisclosureGroup(isExpanded: $customExpanded) {
					ForEach(categoriesSorted.filter { $0.custom }, id: \.self) { category in
						SFSymbolsLiteSideCellView(selectedCategory: $selectedCategory, category: category)
							.swipeActions(edge: .trailing, allowsFullSwipe: true) {
								if category.custom {
									Button(role: .destructive) {
										symbols.forEach { $0.categories.remove(category) }
										categories.remove(category)
										if selectedCategory == category {
											selectedCategory = categoriesSorted.first
										}
										SymbolsData.shared.save(categories: categories, symbols: symbols)
									} label: {
										Label("Delete", systemImage: "trash")
									}
								}
							}
							.onDrop(
								of: [.transferableSymbol],
								delegate: TransferableDelegate(
									types: [.transferableSymbol],
									onDropSymbol: { id in
										if let first = symbols.first(where: { $0.id == id }) {
											Task { @MainActor in
												first.categories.insert(category)
												SymbolsData.shared.save(symbols: symbols)
											}
										}
									}
								)
							)
					}
				} label: {
					SFSymbolsLiteSideDisclosureCellView(image: "square.grid.2x2", label: "Custom")
				}
			}
			.listStyle(.sidebar)

			SFSymbolsLiteSideToolbarView(categories: $categories, symbols: $symbols)
		}
	}
}
