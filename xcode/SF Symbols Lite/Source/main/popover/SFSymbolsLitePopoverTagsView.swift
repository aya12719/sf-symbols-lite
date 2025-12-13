import SwiftUI

struct SFSymbolsLitePopoverTagsView: View {

	@Environment(\.dismiss) private var dismiss
	@Binding var symbols: Set<Symbol>
	@State private var tag: String = ""
	var selectedSymbol: Symbol?

	private func addTag() {
		let tag = SymbolTag(keyword: tag.trimmingCharacters(in: .whitespacesAndNewlines), custom: true)
		if let selectedSymbol {
			selectedSymbol.tags.insert(tag)
		}
		SymbolsData.shared.save(symbols: symbols)
	}

	var body: some View {
		VStack {
			HStack {
				TextField("Tag", text: $tag)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						if tag.count > 0 {
							addTag()
							dismiss()
						}
					}
			}

			HStack {
				Spacer()
				Button("Cancel") {
					dismiss()
				}
				Button("OK") {
					if tag.count > 0 {
						addTag()
						dismiss()
					}
				}
				.buttonStyle(.borderedProminent)
				.keyboardShortcut(.defaultAction)
				.disabled(tag.isEmpty)
			}
		}
		.frame(width: 300)
		.padding(20)
	}
}
