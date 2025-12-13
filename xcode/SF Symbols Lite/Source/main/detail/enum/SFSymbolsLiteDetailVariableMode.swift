import SwiftUI

enum SFSymbolsLiteDetailVariableMode: String, Codable, CaseIterable, Hashable {

	case color
	case draw

	var asVariableMode: SymbolVariableValueMode {
		switch self {
		case .color:
			return .color
		case .draw:
			return .draw
		}
	}
}
