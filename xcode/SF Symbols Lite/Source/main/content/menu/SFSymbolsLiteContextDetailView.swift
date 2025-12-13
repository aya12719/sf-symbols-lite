import SwiftUI

struct SFSymbolsLiteContextDetailView: View {

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

	var body: some View {

		SFSymbolsLiteContextView(
			symbols: $symbols,
			symbol: symbol,
			size: size,
			weight: weight,
			renderingMode: renderingMode,
			gradient: gradient,
			variable: variable,
			variableMode: variableMode,
			variableValue: variableValue,
			color1: color1,
			color2: color2,
			color3: color3
		)
	}
}
