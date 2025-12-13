import SwiftUI

struct SFSymbolsLiteDetailCategoryView: View {

	@Binding var refreshID: UUID
	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@Binding var category: SymbolCategory?
	@ObservedObject var symbol: Symbol
	@State private var showDeleteAlert: Bool = false
	@State private var toDelete: SymbolCategory?
	@State private var showAddPopover: Bool = false

	@AppStorage("SFSymbolsLiteDetailCategoryViewIsExpanded") private var isExpanded: Bool = false

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Button {
					isExpanded.toggle()
				} label: {
					Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 10, height: 10)
						.foregroundStyle(.secondary)
						.contentShape(Rectangle())
				}
				.buttonStyle(.plain)

				Text("CATEGORIES")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				if symbol.categories.count > 0 {
					SFSymbolsLiteDetailGridLayout(horizontalSpacing: 6, verticalSpacing: 6) {
						ForEach(symbol.categoriesSorted, id: \.self) { symbolCategory in
							if symbolCategory.custom {
								HStack {
									Text(symbolCategory.glyph + " " + symbolCategory.label)

									Button {
										toDelete = symbolCategory
										showDeleteAlert = true
									} label: {
										Image(systemName: "trash")
											.foregroundStyle(.primary)
											.font(.body)
									}
									.padding(.leading, 0)
									.padding(.trailing, 0)
									.buttonStyle(.plain)
								}
								.tokenSection(selected: category == symbolCategory)
								.draggable(TransferableCategory(id: symbolCategory.id, symbol: symbolCategory.symbol, name: symbolCategory.name, glyph: symbolCategory.glyph))
								.onTapGesture {
									category = symbolCategory
								}
							} else {
								HStack {
									Text(symbolCategory.glyph + " " + symbolCategory.label)
								}
								.tokenSection(selected: category == symbolCategory)
								.onTapGesture {
									category = symbolCategory
								}
							}
						}
					}
				} else {
					HStack {
						Spacer()
						Text("No Categories")
							.font(.body)
							.fontWeight(.light)
							.foregroundStyle(.secondary)
						Spacer()
					}
					.frame(maxWidth: .infinity, minHeight: 28)
					.overlay(
						RoundedRectangle(cornerRadius: 6)
							.stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
							.foregroundStyle(.secondary.opacity(0.2))
					)
				}

				HStack {
					Button {
						showAddPopover = true
					} label: {
						Image(systemName: "plus")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 10, height: 10)
							.foregroundStyle(.secondary)
							.contentShape(Rectangle())
							.popover(isPresented: $showAddPopover, arrowEdge: .top) {
								SFSymbolsLitePopoverCategoriesView(categories: $categories, symbols: $symbols, selectedSymbol: symbol)
							}
					}
					.buttonStyle(.plain)
					Spacer()
				}
				.padding(.top, 0)
			}
		}
		.alert("Remove Category", isPresented: $showDeleteAlert, presenting: toDelete) { symbolCategory in
			Button("Delete", role: .destructive) {
				symbol.categories.remove(symbolCategory)
				SymbolsData.shared.save(symbols: symbols)
				refreshID = UUID()
			}
			Button("Cancel", role: .cancel) {}
		} message: { symbolCategory in
			Text("Are you sure you want to remove \"\(symbolCategory.label)\"?")
		}
	}
}
