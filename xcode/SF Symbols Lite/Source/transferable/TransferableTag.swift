import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static let transferableTag = UTType(importedAs: "com.ruiaureliano.sf-symbols-lite.transferable.tag", conformingTo: .text)
}

struct TransferableTag: Codable, Transferable {

	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .transferableTag)
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
