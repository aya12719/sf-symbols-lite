import SwiftUI

enum SFSymbolsLiteDetailMode: String, Codable, CaseIterable, Hashable {

	case monochrome = "Monochrome"
	case hierarchical = "Hierarchical"
	case palette = "Palette"
	case multicolor = "Multicolor"

	var asRenderingMode: SymbolRenderingMode {
		switch self {
		case .monochrome:
			return .monochrome
		case .hierarchical:
			return .hierarchical
		case .palette:
			return .palette
		case .multicolor:
			return .multicolor
		}
	}
}
