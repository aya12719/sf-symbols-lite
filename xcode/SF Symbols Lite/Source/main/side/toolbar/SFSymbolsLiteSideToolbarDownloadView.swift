import SwiftUI

struct SFSymbolsLiteSideToolbarDownloadView: View {

	@State private var newBuild: Bool = false
	@State private var newBuildVersion: String = ""
	@State private var newBuildURL: URL?
	@AppStorage("SFSymbolsLiteSideToolbarDownloadVersionIngore") private var newBuildIgnore: String?

	var body: some View {
		HStack {
			if newBuild && newBuildVersion != newBuildIgnore {
				HStack {
					Button {
						if let url = newBuildURL {
							NSWorkspace.shared.open(url)
						}
					} label: {
						Label("**Version:** \(newBuildVersion)", systemImage: "sparkles")
					}
					.padding(.leading, 5)
					.buttonStyle(.plain)

					Button {
						newBuildIgnore = newBuildVersion
						newBuild = false
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
					.padding(.trailing, 5)
					.padding(.vertical, 5)
					.buttonStyle(.plain)
				}
				.foregroundStyle(.white)
				.background(
					RoundedRectangle(cornerRadius: 16)
						.fill(Color.accent)
				)
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color.primary.opacity(0.1))
				)
				.padding(.trailing, 15)
				.padding(.bottom, 15)
			} else {
				EmptyView()
			}
		}
		.task {
			newBuildIgnore = "1qqq"
			guard let url = URL(string: "https://api.github.com/repos/ruiaureliano/sf-symbols-lite/releases") else {
				return
			}
			Task {
				let request = URLRequest(url: url)
				let (data, _) = try await URLSession.shared.data(for: request)
				if var releases = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
					releases.sort { dictionary1, dictionary2 in
						let tagName1: String = dictionary1["tag_name"] as? String ?? ""
						let tagName2: String = dictionary2["tag_name"] as? String ?? ""
						return tagName1.compare(tagName2) != .orderedAscending
					}
					guard
						let release = releases.first,
						let tagName = release["tag_name"] as? String,
						let assets = release["assets"] as? [[String: Any]],
						let asset = assets.first,
						let browserDownloadURL = asset["browser_download_url"] as? String,
						let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
					else {
						return
					}

					switch version.compare(tagName, options: .numeric, range: nil, locale: nil) {
					case .orderedAscending:
						newBuildVersion = tagName
						newBuildURL = URL(string: browserDownloadURL)
						newBuild = true
					case .orderedSame:
						break
					case .orderedDescending:
						break
					}
				}
			}
		}
	}
}
