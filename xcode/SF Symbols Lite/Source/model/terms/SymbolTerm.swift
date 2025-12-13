import Foundation

final class SymbolTerm: Codable, Hashable {

	private enum CodingKeys: String, CodingKey {
		case id
		case keyword
		case custom
	}

	let id: String
	let keyword: String
	let custom: Bool

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(keyword, forKey: .keyword)
		try container.encode(custom, forKey: .custom)
	}

	init(keyword: String, custom: Bool = false) {
		self.id = "term.\(keyword)".lowercased()
		self.keyword = keyword.lowercased()
		self.custom = custom
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? "term.unknown"
		self.keyword = try container.decodeIfPresent(String.self, forKey: .keyword) ?? ""
		self.custom = try container.decodeIfPresent(Bool.self, forKey: .custom) ?? false
	}

	static func == (lhs: SymbolTerm, rhs: SymbolTerm) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
