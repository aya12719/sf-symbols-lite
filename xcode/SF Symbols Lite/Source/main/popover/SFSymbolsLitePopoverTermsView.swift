import SwiftUI

struct SFSymbolsLitePopoverTermsView: View {

	@Environment(\.dismiss) private var dismiss
	@Binding var symbols: Set<Symbol>
	@State private var term: String = ""
	var selectedSymbol: Symbol?

	private func addTerm() {
		let term = SymbolTerm(keyword: term.trimmingCharacters(in: .whitespacesAndNewlines), custom: true)
		if let selectedSymbol {
			selectedSymbol.terms.insert(term)
		}
		SymbolsData.shared.save(symbols: symbols)
	}

	var body: some View {
		VStack {
			HStack {
				TextField("Term", text: $term)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						if term.count > 0 {
							addTerm()
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
					if term.count > 0 {
						addTerm()
						dismiss()
					}
				}
				.buttonStyle(.borderedProminent)
				.keyboardShortcut(.defaultAction)
				.disabled(term.isEmpty)
			}
		}
		.frame(width: 300)
		.padding(20)
	}
}
