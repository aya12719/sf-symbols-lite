import Foundation
import SwiftUI

struct SFSymbolsLiteContextContentView: View {

	@Binding var symbols: Set<Symbol>
	@ObservedObject var symbol: Symbol

	var body: some View {

		SFSymbolsLiteContextView(symbols: $symbols, symbol: symbol)
	}
}
