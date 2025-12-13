import Cocoa

extension JSONEncoder {

	static let standard: JSONEncoder = {
		let encoder = JSONEncoder()
		#if DEBUG
			encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		#else
			encoder.outputFormatting = [.sortedKeys]
		#endif
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()
}
