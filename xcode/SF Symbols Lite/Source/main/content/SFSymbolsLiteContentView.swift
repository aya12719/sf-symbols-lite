import SwiftUI

extension SFSymbolsLiteContentView {

	private var title: String {
		var title: String = ""
		if let selectedCategory {
			title = selectedCategory.label + " (\(available.count) symbols)"
		}
		return title
	}

	private var available: [Symbol] {
		return
			symbols
			.filter {
				$0.filteredSearch(debounceSearch) && $0.filteredFavorites(favorites) && $0.filteredCategory(selectedCategory) && $0.filteredTags(tags)
			}
			.sorted {
				$0.name < $1.name
			}
	}

	private var emptyTitle: String {
		if !tags.isEmpty {
			return "No Matching Symbols for Tags"
		} else if favorites {
			return "No Favorite Symbols"
		} else if !search.isEmpty {
			return "No Matching Symbols"
		} else if selectedCategory != nil {
			return "No Symbols in Category"
		} else {
			return "No Symbols"
		}
	}

	private var emptySubtitle: String {
		if !tags.isEmpty {
			return "Try removing or adjusting the selected tags."
		} else if favorites {
			return "You haven't added any symbols to your favorites yet."
		} else if !search.isEmpty {
			return "Try adjusting your search or checking another category."
		} else if let selectedCategory {
			return "The category “\(selectedCategory.name)” doesn't contain any symbols."
		} else {
			return "Start exploring SF Symbols or use the search above."
		}
	}
}

struct SFSymbolsLiteContentView: View {

	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@Binding var selectedCategory: SymbolCategory?
	@Binding var selectedSymbol: Symbol?
	@Binding var search: String
	@Binding var tags: Set<SymbolTag>
	@Binding var favorites: Bool

	@State private var debounceSearch: String = ""
	@State private var debounceTask: Task<Void, Never>?

	@AppStorage("SFSymbolsLiteContentViewLayoutMode") private var layoutMode: SFSymbolsLiteContentViewLayoutMode = .grid

	var body: some View {
		Group {
			if available.count == 0 {
				VStack(spacing: 12) {
					Image(systemName: "magnifyingglass")
						.font(.system(size: 60))
						.symbolRenderingMode(.hierarchical)
						.foregroundStyle(.secondary)

					Text(emptyTitle)
						.font(.title2)
						.fontWeight(.semibold)
						.foregroundStyle(.secondary)

					Text(emptySubtitle)
						.font(.body)
						.multilineTextAlignment(.center)
						.foregroundStyle(.secondary)
						.padding(.horizontal)

					Button {
						tags.removeAll()
						search = ""
						favorites = false
					} label: {
						Text("Clear Filters")
					}
					.buttonStyle(.borderedProminent)
				}
				.frame(maxWidth: 320)
				.padding()
			} else {
				switch layoutMode {
				case .list:
					List(available, id: \.self, selection: $selectedSymbol) { symbol in
						SFSymbolsLiteContentListCellView(categories: $categories, symbols: $symbols, symbol: symbol)
					}
				case .grid:
					ScrollView {
						LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
							ForEach(available, id: \.self) { symbol in
								SFSymbolsLiteContentGridCellView(categories: $categories, symbols: $symbols, selectedSymbol: $selectedSymbol, symbol: symbol)
							}
						}
						.padding()
					}
					.contentShape(Rectangle())
					.onTapGesture {
						selectedSymbol = nil
					}
				}
			}
		}
		.navigationTitle(title)
		.toolbar {
			ToolbarItem(placement: .automatic) {
				Spacer()
			}

			ToolbarItem(placement: .automatic) {
				Button {
					favorites.toggle()
				} label: {
					Image(systemName: favorites ? "heart.fill" : "heart")
						.foregroundStyle(favorites ? Color.accentColor : .primary)
				}
			}

			ToolbarItem(placement: .automatic) {
				Spacer()
			}

			ToolbarItem(placement: .automatic) {
				Button {
					layoutMode = .grid
				} label: {
					Image(systemName: "rectangle.grid.2x2")
						.foregroundStyle(layoutMode == .grid ? Color.accentColor : .primary)
				}
			}

			ToolbarItem(placement: .automatic) {
				Button {
					layoutMode = .list
				} label: {
					Image(systemName: "text.justify")
						.foregroundStyle(layoutMode == .list ? Color.accentColor : .primary)
				}
			}
		}
		.onChange(of: search) {
			debounceTask?.cancel()
			debounceTask = Task {
				try? await Task.sleep(nanoseconds: 200_000_000)
				guard !Task.isCancelled else { return }
				await MainActor.run {
					debounceSearch = search
				}
			}
		}
	}
}
