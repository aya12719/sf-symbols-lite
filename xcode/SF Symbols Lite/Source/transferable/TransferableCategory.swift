import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static let transferableCategory = UTType(importedAs: "com.ruiaureliano.sf-symbols-lite.transferable.category", conformingTo: .text)
}

struct TransferableCategory: Codable, Transferable {

	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .transferableCategory)
			.suggestedFileName { item in
				return MainActor.assumeIsolated {
					item.name
				}
			}
	}

	var id: String = ""
	var symbol: String = ""
	var name: String = ""
	var glyph: String = ""

	init(id: String, symbol: String, name: String, glyph: String) {
		self.id = id
		self.symbol = symbol
		self.name = name
		self.glyph = glyph
	}
}
