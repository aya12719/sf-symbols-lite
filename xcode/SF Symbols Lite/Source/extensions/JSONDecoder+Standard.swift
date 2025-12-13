import Cocoa

extension JSONDecoder {

	static let standard: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
}
