import Combine
import Foundation

final class Symbol: Codable, ObservableObject, Hashable {

	static var null: Symbol {
		Symbol(name: "null.null.null.null")
	}

	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case glyph
		case categories
		case platform
		case tags
		case terms
		case metadata
		case favorite
	}

	let id: String
	let name: String
	let glyph: String
	@Published var categories: Set<SymbolCategory> = []
	let platform: SymbolPlatform?
	@Published var tags: Set<SymbolTag> = []
	@Published var terms: Set<SymbolTerm> = []
	let metadata: [String]
	@Published var favorite: Bool = false

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.id, forKey: .id)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.glyph, forKey: .glyph)
		try container.encode(self.categories, forKey: .categories)
		try container.encodeIfPresent(self.platform, forKey: .platform)
		try container.encode(self.tags, forKey: .tags)
		try container.encode(self.terms, forKey: .terms)
		try container.encode(self.metadata, forKey: .metadata)
		try container.encode(self.favorite, forKey: .favorite)
	}

	init(
		name: String,
		glyph: String = "",
		categories: [SymbolCategory] = [],
		platform: SymbolPlatform? = nil,
		tags: [SymbolTag] = [],
		terms: [SymbolTerm] = [],
		metadata: [String] = [],
		favorite: Bool = false
	) {
		self.id = "symbol.\(name)".lowercased()
		self.name = name.lowercased()
		self.glyph = glyph
		self.categories = Set(categories)
		self.platform = platform
		self.tags = Set(tags)
		self.terms = Set(terms)
		self.metadata = metadata
		self.favorite = favorite
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? "symbol.unknown"
		self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
		self.glyph = try container.decodeIfPresent(String.self, forKey: .glyph) ?? ""
		self.categories = try container.decodeIfPresent(Set<SymbolCategory>.self, forKey: .categories) ?? []
		self.platform = try container.decodeIfPresent(SymbolPlatform.self, forKey: .platform)
		self.tags = try container.decodeIfPresent(Set<SymbolTag>.self, forKey: .tags) ?? []
		self.terms = try container.decodeIfPresent(Set<SymbolTerm>.self, forKey: .terms) ?? []
        self.metadata = try container.decodeIfPresent([String].self, forKey: .metadata) ?? []
		self.favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite) ?? false
	}

	static func == (lhs: Symbol, rhs: Symbol) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension Symbol {

	var categoriesSorted: [SymbolCategory] {
		categories.sorted {
			if $0.name.lowercased() == "all" { return true }
			if $1.name.lowercased() == "all" { return false }
			return $0.name.localizedCompare($1.name) == .orderedAscending
		}
	}

	var tagsSorted: [SymbolTag] {
		return tags.sorted { $0.keyword < $1.keyword }
	}

	var termsSorted: [SymbolTerm] {
		return terms.sorted { $0.keyword < $1.keyword }
	}
}
