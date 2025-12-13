import Foundation

final class SymbolCategory: Codable, Hashable {

	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case symbol
		case glyph
		case label
		case custom
	}

	let id: String
	let name: String
	let symbol: String
	let glyph: String
	let label: String
	let custom: Bool

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(symbol, forKey: .symbol)
		try container.encode(glyph, forKey: .glyph)
		try container.encode(label, forKey: .label)
		try container.encode(custom, forKey: .custom)
	}

	init(name: String, symbol: String = "", glyph: String = "", label: String = "", custom: Bool = false) {
		self.id = "category.\(custom ? "custom" : "default").\(name)".replacingOccurrences(of: " ", with: ".").lowercased()
		self.name = name.lowercased()
		self.symbol = symbol
		self.glyph = glyph
		self.label = label
		self.custom = custom
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
		self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
		self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
		self.glyph = try container.decodeIfPresent(String.self, forKey: .glyph) ?? ""
		self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
		self.custom = try container.decodeIfPresent(Bool.self, forKey: .custom) ?? false
	}

	static func == (lhs: SymbolCategory, rhs: SymbolCategory) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
