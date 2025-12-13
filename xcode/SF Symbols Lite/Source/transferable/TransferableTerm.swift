import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static let transferableTerm = UTType(importedAs: "com.ruiaureliano.sf-symbols-lite.transferable.term", conformingTo: .text)
}

struct TransferableTerm: Codable, Transferable {

	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .transferableTerm)
			.suggestedFileName { item in
				return MainActor.assumeIsolated {
					item.keyword
				}
			}
	}

	var id: String = ""
	var keyword: String = ""
	var custom: Bool = false

	init(id: String, keyword: String, custom: Bool) {
		self.id = id
		self.keyword = keyword
		self.custom = custom
	}
}
