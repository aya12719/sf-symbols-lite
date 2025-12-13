import SwiftUI

struct SFSymbolsLiteDetailSymbolView: View {

	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol
	@Binding var size: CGFloat
	@Binding var weight: Font.Weight
	@Binding var renderingMode: SFSymbolsLiteDetailMode
	@Binding var gradient: Bool
	@Binding var variable: Bool
	@Binding var variableMode: SFSymbolsLiteDetailVariableMode
	@Binding var variableValue: Float
	@Binding var color1: Color
	@Binding var color2: Color
	@Binding var color3: Color

	@AppStorage("SFSymbolsLiteDetailSymbolViewIsExpanded") private var isExpanded: Bool = true

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Button {
					isExpanded.toggle()
				} label: {
					Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 10, height: 10)
						.foregroundStyle(.secondary)
						.contentShape(Rectangle())
				}
				.buttonStyle(.plain)

				Text("SYMBOL: ")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)

				Text(symbol.name)
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.primary)

				Spacer()

				Button {
					symbol.favorite.toggle()
					SymbolsData.shared.save(symbols: symbols)
				} label: {
					Image(systemName: symbol.favorite ? "heart.fill" : "heart")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 16, height: 16)
						.foregroundStyle(.primary)
						.contentShape(Rectangle())
				}
				.buttonStyle(.plain)
				.padding(.trailing, 5)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				VStack {
					ZStack {
						Image(systemName: symbol.name, variableValue: Double(variable ? variableValue / 100 : 1))
							.resizable()
							.scaledToFit()
							.frame(width: size, height: size)
							.font(.system(size: size, weight: weight))
							.symbolRenderingMode(renderingMode.asRenderingMode)
							.symbolColorRenderingMode(gradient ? .gradient : .flat)
							.symbolVariableValueMode(variableMode.asVariableMode)
							.foregroundStyle(color1, color2, color3)
							.contextMenu {
								if !symbol.glyph.isEmpty {
									SFSymbolsLiteContextDetailView(
										symbols: $symbols,
										symbol: symbol,
										size: $size,
										weight: $weight,
										renderingMode: $renderingMode,
										gradient: $gradient,
										variable: $variable,
										variableMode: $variableMode,
										variableValue: $variableValue,
										color1: $color1,
										color2: $color2,
										color3: $color3
									)
								}
							}
							.draggable(TransferableSymbol(id: symbol.id, name: symbol.name, glyph: symbol.glyph))
					}
					.frame(width: 512, height: 512)
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(40)
					.background(Color.clear)
					.contentShape(Rectangle())

					Picker("", selection: $size) {
						Text("16").tag(CGFloat(16))
						Text("32").tag(CGFloat(32))
						Text("64").tag(CGFloat(64))
						Text("128").tag(CGFloat(128))
						Text("256").tag(CGFloat(256))
						Text("512").tag(CGFloat(512))
					}
					.pickerStyle(.segmented)
					.frame(width: 300)
					.padding(.bottom, 10)
				}
			}
		}
	}
}
