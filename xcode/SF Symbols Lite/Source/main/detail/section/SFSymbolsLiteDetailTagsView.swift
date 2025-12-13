import SwiftUI

struct SFSymbolsLiteDetailTagsView: View {

	@Binding var refreshID: UUID
	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol
	@Binding var tags: Set<SymbolTag>
	@State private var showDeleteAlert: Bool = false
	@State private var toDelete: SymbolTag?
	@State private var showAddPopover: Bool = false

	@AppStorage("SFSymbolsLiteDetailTagsViewIsExpanded") private var isExpanded: Bool = false

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

				Text("TAGS")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				if symbol.tags.count > 0 {
					SFSymbolsLiteDetailGridLayout(horizontalSpacing: 6, verticalSpacing: 6) {
						ForEach(Array(symbol.tagsSorted), id: \.self) { symbolTag in
							if symbolTag.custom {
								HStack {
									Text("􀋡 " + symbolTag.keyword.lowercased())

									Button {
										toDelete = symbolTag
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
								.tokenSection(selected: tags.contains(symbolTag))
								.draggable(TransferableTag(id: symbolTag.id, keyword: symbolTag.keyword, custom: symbolTag.custom))
								.onTapGesture {
									if tags.contains(symbolTag) {
										tags.remove(symbolTag)
									} else {
										tags.insert(symbolTag)
									}
								}
							} else {
								HStack {
									Text("􀋡 " + symbolTag.keyword.lowercased())
								}
								.tokenSection(selected: tags.contains(symbolTag))
								.onTapGesture {
									if tags.contains(symbolTag) {
										tags.remove(symbolTag)
									} else {
										tags.insert(symbolTag)
									}
								}
							}
						}
					}
				} else {
					HStack {
						Spacer()
						Text("No Tags")
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
								SFSymbolsLitePopoverTagsView(symbols: $symbols, selectedSymbol: symbol)
							}
					}
					.buttonStyle(.plain)
					Spacer()
				}
				.padding(.top, 0)
			}
		}
		.alert("Remove Tag", isPresented: $showDeleteAlert, presenting: toDelete) { symbolTag in
			Button("Delete", role: .destructive) {
				symbol.tags.remove(symbolTag)
				SymbolsData.shared.save(symbols: symbols)
				refreshID = UUID()
			}
			Button("Cancel", role: .cancel) {}
		} message: { symbolTag in
			Text("Are you sure you want to remove \"\(symbolTag.keyword)\"?")
		}
	}
}
