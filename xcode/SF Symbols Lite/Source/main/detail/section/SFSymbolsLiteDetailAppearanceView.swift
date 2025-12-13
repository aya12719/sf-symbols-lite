import SwiftUI

struct SFSymbolsLiteDetailAppearanceView: View {

	@Binding var renderingMode: SFSymbolsLiteDetailMode
	@Binding var gradient: Bool
	@Binding var variable: Bool
	@Binding var variableMode: SFSymbolsLiteDetailVariableMode
	@Binding var variableValue: Float
	@Binding var color1: Color
	@Binding var color2: Color
	@Binding var color3: Color

	@AppStorage("SFSymbolsLiteDetailAppearanceViewIsExpanded") private var isExpanded: Bool = false

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

				Text("APPEARANCE")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				VStack(spacing: 5) {
					HStack(alignment: .center) {
						Image(systemName: "paintpalette")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Rendering Mode")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						Picker("", selection: $renderingMode) {
							ForEach(SFSymbolsLiteDetailMode.allCases, id: \.self) { mode in
								Text(mode.rawValue).tag(mode)
							}
						}
						.pickerStyle(.menu)
						.padding(.trailing, 10)
					}
					.detailInsideSection()

					HStack(alignment: .center) {
						Image(systemName: "circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.symbolColorRenderingMode(gradient ? .gradient : .flat)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Gradients")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						Toggle("", isOn: $gradient)
							.toggleStyle(.switch)
							.controlSize(.small)
							.labelsHidden()
							.padding(.trailing, 10)
					}
					.detailInsideSection()

					HStack(alignment: .center) {
						Image(systemName: "slider.horizontal.below.square.and.square.filled")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Variable")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						Picker("", selection: $variableMode) {
							ForEach(SFSymbolsLiteDetailVariableMode.allCases, id: \.self) { mode in
								Text(mode.rawValue).tag(mode)
							}
						}
						.disabled(!variable)
						.pickerStyle(.menu)

						Slider(value: $variableValue, in: 0...100)
							.disabled(!variable)
							.frame(width: 150)

						ZStack(alignment: .trailing) {
							TextField("", value: $variableValue, format: .number)
								.frame(width: 50)
								.textFieldStyle(.roundedBorder)
								.disabled(!variable)

							Stepper("", value: $variableValue, in: 0...100)
								.labelsHidden()
								.fixedSize()
								.controlSize(.small)
								.disabled(!variable)
						}
						Toggle("", isOn: $variable)
							.toggleStyle(.switch)
							.controlSize(.small)
							.labelsHidden()
							.padding(.trailing, 10)
					}
					.detailInsideSection()
					.onChange(of: variableValue) {
						if variableValue < 0 {
							variableValue = 0
						} else if variableValue > 100 {
							variableValue = 100
						} else {
							variableValue = round(variableValue)
						}
					}

					VStack(alignment: .center, spacing: 0) {
						HStack(alignment: .center) {
							Image(systemName: "circle.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(color1)
								.padding(.leading, 10)
								.padding(.vertical, 10)
								.onTapGesture {
									color1 = Color.accentColor
								}

							Text("Primary Color")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)
								.onTapGesture {
									color1 = Color.accentColor
								}

							Spacer()

							ColorPicker("", selection: $color1, supportsOpacity: true)
								.labelsHidden()
								.padding(.trailing, 10)
						}
						if renderingMode == .palette {
							HStack(alignment: .center) {
								Image(systemName: "circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 16, height: 16)
									.foregroundStyle(color2)
									.padding(.leading, 10)
									.padding(.vertical, 10)
									.onTapGesture {
										color2 = Color.accentColor.opacity(0.6)
									}

								Text("Secondary Color")
									.font(.body)
									.fontWeight(.regular)
									.foregroundStyle(.primary)
									.onTapGesture {
										color2 = Color.accentColor.opacity(0.6)
									}

								Spacer()

								ColorPicker("", selection: $color2, supportsOpacity: true)
									.labelsHidden()
									.padding(.trailing, 10)
							}

							HStack(alignment: .center) {
								Image(systemName: "circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 16, height: 16)
									.foregroundStyle(color3)
									.padding(.leading, 10)
									.padding(.vertical, 10)
									.onTapGesture {
										color3 = Color.accentColor.opacity(0.3)
									}

								Text("Tertiary Color")
									.font(.body)
									.fontWeight(.regular)
									.foregroundStyle(.primary)
									.onTapGesture {
										color3 = Color.accentColor.opacity(0.3)
									}

								Spacer()

								ColorPicker("", selection: $color3, supportsOpacity: true)
									.labelsHidden()
									.padding(.trailing, 10)
							}
						}
					}
					.detailInsideSection()
				}
			}
		}
	}
}
