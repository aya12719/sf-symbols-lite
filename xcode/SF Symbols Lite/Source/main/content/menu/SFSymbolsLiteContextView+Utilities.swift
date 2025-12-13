import SwiftUI

extension SFSymbolsLiteContextView {

	func generatePNG<V: View>(image: V) -> NSImage? {
		let renderer = ImageRenderer(content: image)
		renderer.scale = 2
		return renderer.nsImage
	}

	func copyPNGtoPasteboard(_ image: NSImage, name: String) {
		guard
			let tiffData = image.tiffRepresentation,
			let bitmap = NSBitmapImageRep(data: tiffData),
			let pngData = bitmap.representation(using: .png, properties: [:])
		else {
			return
		}

		let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name).png")
		try? pngData.write(to: tempURL)
		let pasteboard = NSPasteboard.general
		pasteboard.clearContents()
		pasteboard.writeObjects([tempURL as NSURL])
	}

	func generateSVG(glyph: String, size: CGFloat, weight: Font.Weight) -> String? {
		var font = NSFont(name: "SFPro-Regular", size: size)
		switch weight {
		case .ultraLight:
			font = NSFont(name: "SFPro-Ultralight", size: size)
		case .thin:
			font = NSFont(name: "SFPro-Thin", size: size)
		case .light:
			font = NSFont(name: "SFPro-Light", size: size)
		case .regular:
			font = NSFont(name: "SFPro-Regular", size: size)
		case .medium:
			font = NSFont(name: "SFPro-Medium", size: size)
		case .semibold:
			font = NSFont(name: "SFPro-Semibold", size: size)
		case .bold:
			font = NSFont(name: "SFPro-Bold", size: size)
		case .heavy:
			font = NSFont(name: "SFPro-Heavy", size: size)
		case .black:
			font = NSFont(name: "SFPro-Black", size: size)
		default:
			font = NSFont(name: "SFPro-Regular", size: size)
		}

		guard let font = font else { return nil }

		let ctFont = CTFontCreateWithName(font.fontName as CFString, size, nil)
		var chars: [UniChar] = Array(glyph.utf16)
		var glyphs = [CGGlyph](repeating: 0, count: chars.count)
		let success = CTFontGetGlyphsForCharacters(ctFont, &chars, &glyphs, chars.count)
		guard success, let cgPath = CTFontCreatePathForGlyph(ctFont, glyphs[0], nil) else { return nil }

		let box = cgPath.boundingBox
		var normalize = CGAffineTransform(translationX: -box.origin.x, y: -box.origin.y)
		guard let normalized = cgPath.copy(using: &normalize) else { return nil }

		let viewBox = CGRect(x: 0, y: 0, width: size, height: size)
		let dx = (viewBox.width - box.width) / 2
		let dy = (viewBox.height - box.height) / 2

		var centerTransform = CGAffineTransform(translationX: dx, y: dy)
		guard let centered = normalized.copy(using: &centerTransform) else { return nil }

		return
			"""
			<svg xmlns="http://www.w3.org/2000/svg">
			<path d="\(centered.svg)" fill="000000"/>
			</svg>
			"""
	}
}
