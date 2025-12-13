import SwiftUI

struct SFSymbolsLiteDetailTermsView: View {

	@Binding var refreshID: UUID
	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol
	@Binding var search: String
	@State private var showDeleteAlert: Bool = false
	@State private var toDelete: SymbolTerm?
	@State private var showAddPopover: Bool = false

	@AppStorage("SFSymbolsLiteDetailTermsViewIsExpanded") private var isExpanded: Bool = false

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

				Text("SEARCH")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
					.onTapGesture {
						isExpanded.toggle()
					}
			}

			if isExpanded {
				if symbol.terms.count > 0 {
					SFSymbolsLiteDetailGridLayout(horizontalSpacing: 6, verticalSpacing: 6) {
						ForEach(Array(symbol.termsSorted), id: \.self) { symbolTerm in
							if symbolTerm.custom {
								HStack {
									Text("􀊫 " + symbolTerm.keyword.lowercased())

									Button {
										toDelete = symbolTerm
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
								.tokenSection(selected: search.lowercased() == symbolTerm.keyword.lowercased())
								.draggable(TransferableTerm(id: symbolTerm.id, keyword: symbolTerm.keyword, custom: symbolTerm.custom))
								.onTapGesture {
									if search != symbolTerm.keyword.lowercased() {
										search = symbolTerm.keyword.lowercased()
									} else {
										search = ""
									}
								}
							} else {
								HStack {
									Text("􀊫 " + symbolTerm.keyword.lowercased())
								}
								.tokenSection(selected: search.lowercased() == symbolTerm.keyword.lowercased())
								.onTapGesture {
									if search != symbolTerm.keyword.lowercased() {
										search = symbolTerm.keyword.lowercased()
									} else {
										search = ""
									}
								}
							}
						}
					}
				} else {
					HStack {
						Spacer()
						Text("No Terms")
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
								SFSymbolsLitePopoverTermsView(symbols: $symbols, selectedSymbol: symbol)
							}
					}
					.buttonStyle(.plain)
					Spacer()
				}
				.padding(.top, 0)
			}

		}
		.alert("Remove Term", isPresented: $showDeleteAlert, presenting: toDelete) { symbolTerm in
			Button("Delete", role: .destructive) {
				symbol.terms.remove(symbolTerm)
				SymbolsData.shared.save(symbols: symbols)
				refreshID = UUID()
			}
			Button("Cancel", role: .cancel) {}
		} message: { symbolTerm in
			Text("Are you sure you want to remove \"\(symbolTerm.keyword)\"?")
		}
	}
}
