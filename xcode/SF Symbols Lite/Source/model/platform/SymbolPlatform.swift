import Foundation

final class SymbolPlatform: Codable {

	private enum CodingKeys: String, CodingKey {
		case year
		case iOS
		case macOS
		case watchOS
		case tvOS
		case visionOS
	}

	let year: String
	let iOS: String?
	let macOS: String?
	let watchOS: String?
	let tvOS: String?
	let visionOS: String?

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(year, forKey: .year)
		try container.encodeIfPresent(iOS, forKey: .iOS)
		try container.encodeIfPresent(macOS, forKey: .macOS)
		try container.encodeIfPresent(watchOS, forKey: .watchOS)
		try container.encodeIfPresent(tvOS, forKey: .tvOS)
		try container.encodeIfPresent(visionOS, forKey: .visionOS)
	}

	init(year: String, iOS: String? = nil, macOS: String? = nil, watchOS: String? = nil, tvOS: String? = nil, visionOS: String? = nil) {
		self.year = year
		self.iOS = iOS
		self.macOS = macOS
		self.watchOS = watchOS
		self.tvOS = tvOS
		self.visionOS = visionOS
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.year = try container.decodeIfPresent(String.self, forKey: .year) ?? ""
		self.iOS = try container.decodeIfPresent(String.self, forKey: .iOS)
		self.macOS = try container.decodeIfPresent(String.self, forKey: .macOS)
		self.watchOS = try container.decodeIfPresent(String.self, forKey: .watchOS)
		self.tvOS = try container.decodeIfPresent(String.self, forKey: .tvOS)
		self.visionOS = try container.decodeIfPresent(String.self, forKey: .visionOS)
	}
}
