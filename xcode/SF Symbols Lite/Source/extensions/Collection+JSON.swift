import Foundation

extension Array {

	var json: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonSorted: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonPretty: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonSortedPretty: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonData: Data? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				return try JSONSerialization.data(withJSONObject: self, options: [])
			}
		} catch {
		}
		return nil
	}
}

extension Dictionary {

	var json: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonSorted: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonPretty: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonSortedPretty: String? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
				return String(data: data, encoding: .utf8)
			}
		} catch {
		}
		return nil
	}

	var jsonData: Data? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				return try JSONSerialization.data(withJSONObject: self, options: [])
			}
		} catch {
		}
		return nil
	}

	var jsonDataPretty: Data? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				return try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
			}
		} catch {
		}
		return nil
	}

	var jsonDataSorted: Data? {
		do {
			if JSONSerialization.isValidJSONObject(self) {
				return try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
			}
		} catch {
		}
		return nil
	}
}
