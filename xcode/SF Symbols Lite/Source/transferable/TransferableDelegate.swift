import SwiftUI
import UniformTypeIdentifiers

struct TransferableDelegate: DropDelegate {

	var types: [UTType]
	var onDropSymbol: ((String) -> Void)?
	var onDropCategory: ((String) -> Void)?
	var onDropTag: ((String) -> Void)?
	var onDropTerm: ((String) -> Void)?

	func validateDrop(info: DropInfo) -> Bool {
		return info.hasItemsConforming(to: types)
	}

	func performDrop(info: DropInfo) -> Bool {

		for provider in info.itemProviders(for: types) {

			provider.loadItem(forTypeIdentifier: UTType.transferableSymbol.identifier) { item, _ in
				guard let url = item as? URL, let data = try? Data(contentsOf: url), let json = data.json as? [String: Any], let id = json["id"] as? String else { return }
				onDropSymbol?(id)
			}

			provider.loadItem(forTypeIdentifier: UTType.transferableCategory.identifier) { item, _ in
				guard let url = item as? URL, let data = try? Data(contentsOf: url), let json = data.json as? [String: Any], let id = json["id"] as? String else { return }
				onDropCategory?(id)
			}

			provider.loadItem(forTypeIdentifier: UTType.transferableTag.identifier) { item, _ in
				guard let url = item as? URL, let data = try? Data(contentsOf: url), let json = data.json as? [String: Any], let id = json["id"] as? String else { return }
				onDropTag?(id)
			}

			provider.loadItem(forTypeIdentifier: UTType.transferableTerm.identifier) { item, _ in
				guard let url = item as? URL, let data = try? Data(contentsOf: url), let json = data.json as? [String: Any], let id = json["id"] as? String else { return }
				onDropTerm?(id)
			}

			break
		}
		return true
	}
}
