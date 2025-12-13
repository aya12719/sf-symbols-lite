import Foundation

extension Symbol {

	func filteredFavorites(_ favorites: Bool) -> Bool {
		return !favorites || favorite
	}

	func filteredCategory(_ category: SymbolCategory?) -> Bool {
		if let category, !self.categories.contains(where: { $0 == category }) {
			return false
		}
		return true
	}

	func filteredTags(_ tags: Set<SymbolTag>) -> Bool {
		if tags.count > 0, !self.tags.contains(where: { tags.contains($0) }) {
			return false
		}
		return true
	}

	func filteredSearch(_ search: String) -> Bool {
		let trim = search.trimmingCharacters(in: .whitespacesAndNewlines)
		guard trim.count >= 3 else { return true }
		let all = Set(self.tags.map { $0.keyword } + self.terms.map { $0.keyword } + [self.name] + [self.glyph] + metadata)
		if !all.contains(where: { $0.localizedCaseInsensitiveContains(trim) }) {
			return false
		}
		return true
	}
}
