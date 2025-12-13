import Foundation

private let kCategoriesFileName = "categories.json"
private let kSymbolsFileName = "symbols.json"

final class SymbolsData {

	static let shared = SymbolsData()

	private init() {}

	func load(completion: ((_ categories: Set<SymbolCategory>?, _ symbols: Set<Symbol>?) -> Void)? = nil) {
		guard
			let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			let dataSymbols = FileManager.default.contents(atPath: "\(url.path)/\(bundleIdentifier)/\(kSymbolsFileName)"),
			let symbols = try? JSONDecoder.standard.decode(Set<Symbol>.self, from: dataSymbols),
			let dataCategories = FileManager.default.contents(atPath: "\(url.path)/\(bundleIdentifier)/\(kCategoriesFileName)"),
			let categories = try? JSONDecoder.standard.decode(Set<SymbolCategory>.self, from: dataCategories)
		else {
			guard
				let url = Bundle.main.url(forResource: "symbols", withExtension: "json"),
				let data = try? Data(contentsOf: url),
				let symbols = try? JSONDecoder.standard.decode(Set<Symbol>.self, from: data)
			else {
				completion?(nil, nil)
				return
			}
			let categories: Set<SymbolCategory> = Set(symbols.flatMap { $0.categories })
			completion?(categories, symbols)
			return
		}
		completion?(categories, symbols)
	}

	func save(categories: Set<SymbolCategory>, symbols: Set<Symbol>, completion: ((_ success: Bool) -> Void)? = nil) {
		guard
			let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			let dataSymbols = try? JSONEncoder.standard.encode(symbols),
			let dataCategories = try? JSONEncoder.standard.encode(categories)
		else {
			completion?(false)
			return
		}

		let directory = "\(url.path)/\(bundleIdentifier)"
		if !FileManager.default.directoryExists(atPath: directory) {
			try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
		}

		let pathSymbols = "\(directory)/\(kSymbolsFileName)"
		let pathCategories = "\(directory)/\(kCategoriesFileName)"
		let successSymbols = FileManager.default.createFile(atPath: pathSymbols, contents: dataSymbols, attributes: nil)
		let successCategories = FileManager.default.createFile(atPath: pathCategories, contents: dataCategories, attributes: nil)

		completion?(successSymbols || successCategories)
	}

	func save(categories: Set<SymbolCategory>, completion: ((_ success: Bool) -> Void)? = nil) {
		guard
			let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			let dataCategories = try? JSONEncoder.standard.encode(categories)
		else {
			completion?(false)
			return
		}

		let directory = "\(url.path)/\(bundleIdentifier)"
		if !FileManager.default.directoryExists(atPath: directory) {
			try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
		}

		let pathCategories = "\(directory)/\(kCategoriesFileName)"
		let successCategories = FileManager.default.createFile(atPath: pathCategories, contents: dataCategories, attributes: nil)

		completion?(successCategories)
	}

	func save(symbols: Set<Symbol>, completion: ((_ success: Bool) -> Void)? = nil) {
		guard
			let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			let dataSymbols = try? JSONEncoder.standard.encode(symbols)
		else {
			completion?(false)
			return
		}

		let directory = "\(url.path)/\(bundleIdentifier)"
		if !FileManager.default.directoryExists(atPath: directory) {
			try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
		}

		let pathSymbols = "\(directory)/\(kSymbolsFileName)"
		let successSymbols = FileManager.default.createFile(atPath: pathSymbols, contents: dataSymbols, attributes: nil)

		completion?(successSymbols)
	}
}
