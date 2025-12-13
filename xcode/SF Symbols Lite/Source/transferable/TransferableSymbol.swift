import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static let transferableSymbol = UTType(importedAs: "com.ruiaureliano.sf-symbols-lite.transferable.symbol", conformingTo: .text)
}

struct TransferableSymbol: Codable, Transferable {

	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .transferableSymbol)
			.suggestedFileName { item in
				return MainActor.assumeIsolated {
					item.name
				}
			}
	}

	var id: String = ""
	var name: String = ""
	var glyph: String = ""

	init(id: String, name: String, glyph: String) {
		self.id = id
		self.name = name
		self.glyph = glyph
	}
}
