import SwiftUI

struct SFSymbolsLiteSideToolbarView: View {

	@Binding var categories: Set<SymbolCategory>
	@Binding var symbols: Set<Symbol>
	@State private var showAddPopover: Bool = false

	var body: some View {

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
						SFSymbolsLitePopoverCategoriesView(categories: $categories, symbols: $symbols, selectedSymbol: nil)
					}
			}
			.padding(.leading, 15)
			.padding(.bottom, 15)
			.buttonStyle(.plain)

			Spacer()
		}
	}
}
