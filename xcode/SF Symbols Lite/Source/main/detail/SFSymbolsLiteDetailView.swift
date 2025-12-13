import SwiftUI

struct SFSymbolsLiteDetailView: View {

	@Binding var refreshID: UUID
	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@Binding var category: SymbolCategory?
	@ObservedObject var symbol: Symbol
	@Binding var search: String
	@Binding var tags: Set<SymbolTag>
	@Binding var favorites: Bool

	@Binding var size: CGFloat
	@Binding var weight: Font.Weight
	@Binding var renderingMode: SFSymbolsLiteDetailMode
	@Binding var gradient: Bool
	@Binding var variable: Bool
	@Binding var variableMode: SFSymbolsLiteDetailVariableMode
	@Binding var variableValue: Float
	@Binding var color1: Color
	@Binding var color2: Color
	@Binding var color3: Color

	var body: some View {
		ZStack {
			if symbol != .null, symbol.filteredSearch(search) && symbol.filteredFavorites(favorites) && symbol.filteredCategory(category) && symbol.filteredTags(tags) {
				List {
					SFSymbolsLiteDetailSymbolView(
						symbols: $symbols,
						symbol: symbol,
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
					.detailSection()

					SFSymbolsLiteDetailAppearanceView(
						renderingMode: $renderingMode,
						gradient: $gradient,
						variable: $variable,
						variableMode: $variableMode,
						variableValue: $variableValue,
						color1: $color1,
						color2: $color2,
						color3: $color3
					)
					.detailSection()

					SFSymbolsLiteDetailCategoryView(
						refreshID: $refreshID,
						categories: $categories,
						symbols: $symbols,
						category: $category,
						symbol: symbol
					)
					.detailSection()

					SFSymbolsLiteDetailPlatformsView(
						symbol: symbol
					)
					.detailSection()

					SFSymbolsLiteDetailTagsView(
						refreshID: $refreshID,
						categories: $categories,
						symbols: $symbols,
						symbol: symbol,
						tags: $tags
					)
					.detailSection()

					SFSymbolsLiteDetailTermsView(
						refreshID: $refreshID,
						categories: $categories,
						symbols: $symbols,
						symbol: symbol,
						search: $search
					)
					.detailSection()
				}
			} else {
				SFSymbolsLiteDetailEmptyView()
			}
		}
		.toolbar {
			ToolbarItem(placement: .automatic) {
				Picker("Weight", selection: $weight) {
					Text("UltraLight").tag(Font.Weight.ultraLight)
					Text("Thin").tag(Font.Weight.thin)
					Text("Light").tag(Font.Weight.light)
					Text("Regular").tag(Font.Weight.regular)
					Text("Medium").tag(Font.Weight.medium)
					Text("Semibold").tag(Font.Weight.semibold)
					Text("Bold").tag(Font.Weight.bold)
					Text("Heavy").tag(Font.Weight.heavy)
					Text("Black").tag(Font.Weight.black)
				}
				.pickerStyle(.menu)
			}
		}
		.frame(minWidth: 700)
	}
}
