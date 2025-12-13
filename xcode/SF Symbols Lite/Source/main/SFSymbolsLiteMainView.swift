import SwiftUI

struct SFSymbolsLiteMainView: View {

	@State private var refreshID: UUID = UUID()
	@State private var categories: Set<SymbolCategory> = []
	@State private var symbols: Set<Symbol> = []
	@State private var selectedCategory: SymbolCategory?
	@State private var selectedSymbol: Symbol?
	@State private var search: String = ""
	@State private var tags: Set<SymbolTag> = []
	@State private var favorites: Bool = false

	@State private var size: CGFloat = 512
	@State private var weight: Font.Weight = .regular
	@State private var renderingMode: SFSymbolsLiteDetailMode = .monochrome
	@State private var gradient: Bool = false
	@State private var variable: Bool = false
	@State private var variableMode: SFSymbolsLiteDetailVariableMode = .draw
	@State private var variableValue: Float = 50
	@State private var color1: Color = Color.accentColor
	@State private var color2: Color = Color.accentColor.opacity(0.6)
	@State private var color3: Color = Color.accentColor.opacity(0.3)

	private var categoriesSorted: [SymbolCategory] {
		categories.sorted {
			if $0.name.lowercased() == "all" { return true }
			if $1.name.lowercased() == "all" { return false }
			return $0.name.localizedCompare($1.name) == .orderedAscending
		}
	}

	private var symbolsSorted: [Symbol] {
		symbols.sorted {
			$0.name < $1.name
		}
	}

	var body: some View {

		ZStack(alignment: .bottom) {
			NavigationSplitView {
				SFSymbolsLiteSideView(
					categories: $categories,
					symbols: $symbols,
					selectedCategory: $selectedCategory,
					selectedSymbol: $selectedSymbol
				)
				.navigationSplitViewColumnWidth(min: 200, ideal: 200)
			} content: {
				SFSymbolsLiteContentView(
					categories: $categories,
					symbols: $symbols,
					selectedCategory: $selectedCategory,
					selectedSymbol: $selectedSymbol,
					search: $search,
					tags: $tags,
					favorites: $favorites
				)
				.navigationSplitViewColumnWidth(min: 500, ideal: 500)
			} detail: {
				SFSymbolsLiteDetailView(
					refreshID: $refreshID,
					categories: $categories,
					symbols: $symbols,
					category: $selectedCategory,
					symbol: selectedSymbol ?? .null,
					search: $search,
					tags: $tags,
					favorites: $favorites,
					size: $size,
					weight: $weight,
					renderingMode: $renderingMode,
					gradient: $gradient,
					variable: $variable,
					variableMode: $variableMode,
					variableValue: $variableValue,
					color1: $color1,
					color2: $color2,
					color3: $color3
				)
			}
			.frame(minHeight: 500, idealHeight: 600)
			.navigationSplitViewStyle(.automatic)

			SFSymbolsLiteMainTagsView(tags: $tags)
		}.onAppear {
			SymbolsData.shared.load { categories, symbols in
				if let categories, let symbols {
					self.categories = categories
					self.symbols = symbols

					if selectedCategory == nil {
						selectedCategory = categoriesSorted.first
					}
					if selectedSymbol == nil {
						selectedSymbol = symbolsSorted.first { $0.categories.contains(where: { $0 == selectedCategory }) }
					}
				}
			}
		}
		.searchable(text: $search, prompt: "Search")
		.id(refreshID)
	}
}

#Preview {
	SFSymbolsLiteMainView()
}
