import SwiftUI

struct SFSymbolsLiteContextView: View {

	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol

	var size: CGFloat?
	var weight: Font.Weight?
	var renderingMode: SFSymbolsLiteDetailMode?
	var gradient: Bool?
	var variable: Bool?
	var variableMode: SFSymbolsLiteDetailVariableMode?
	var variableValue: Float?
	var color1: Color?
	var color2: Color?
	var color3: Color?

	var body: some View {
		Group {
			Button {
				symbol.favorite.toggle()
				SymbolsData.shared.save(symbols: symbols)
			} label: {
				Label(
					symbol.favorite ? "Remove Favorite" : "Add to Favorites",
					systemImage: symbol.favorite ? "heart.fill" : "heart"
				)
			}

			Divider()

			Menu {
				Button {
					NSPasteboard.general.clearContents()
					NSPasteboard.general.setString(symbol.glyph, forType: .string)
				} label: {
					Label("Symbol", systemImage: symbol.name)
				}

				Button {
					NSPasteboard.general.clearContents()
					NSPasteboard.general.setString(symbol.name, forType: .string)
				} label: {
					Label("Name", systemImage: "quote.opening")
				}

				Button {
					if let size, let weight, let renderingMode, let gradient, let variable, let variableMode, let variableValue, let color1, let color2, let color3 {
						let image = Image(systemName: symbol.name, variableValue: Double(variable ? variableValue : 1))
							.resizable()
							.scaledToFit()
							.frame(width: size, height: size)
							.font(.system(size: size, weight: weight))
							.symbolRenderingMode(renderingMode.asRenderingMode)
							.symbolColorRenderingMode(gradient ? .gradient : .flat)
							.symbolVariableValueMode(variableMode.asVariableMode)
							.foregroundStyle(color1, color2, color3)

						if let imagePNG = generatePNG(image: image) {
							copyPNGtoPasteboard(imagePNG, name: symbol.name)
						}
					} else {
						let image = Image(systemName: symbol.name, variableValue: 1)
							.resizable()
							.scaledToFit()
							.frame(width: 64, height: 64)
							.font(.system(size: 64, weight: .regular))
							.foregroundStyle(.black)

						if let imagePNG = generatePNG(image: image) {
							copyPNGtoPasteboard(imagePNG, name: symbol.name)
						}
					}
				} label: {
					Label("PNG", systemImage: "photo")
				}

				Button {
					if let svg = generateSVG(glyph: symbol.glyph, size: size ?? 64, weight: weight ?? .regular) {
						NSPasteboard.general.clearContents()
						NSPasteboard.general.setString(svg, forType: .string)
					}
				} label: {
					Label("SVG", systemImage: "beziercurve")
				}
			} label: {
				Label("Copy", systemImage: "document.on.document")
			}
		}
	}
}
