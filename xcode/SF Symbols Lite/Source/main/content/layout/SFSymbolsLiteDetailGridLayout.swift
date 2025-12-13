import SwiftUI

struct SFSymbolsLiteDetailGridLayout: Layout {

	var horizontalSpacing: CGFloat
	var verticalSpacing: CGFloat

	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {

		guard let availableWidth = proposal.width else { return .zero }

		var x: CGFloat = 0
		var y: CGFloat = 0
		var rowHeight: CGFloat = 0

		for subview in subviews {
			let size = subview.sizeThatFits(.unspecified)
			if x + size.width > availableWidth {
				x = 0
				y += rowHeight + verticalSpacing
				rowHeight = 0
			}

			rowHeight = max(rowHeight, size.height)
			x += size.width + horizontalSpacing
		}

		return CGSize(width: availableWidth, height: y + rowHeight)
	}

	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

		var x = bounds.minX
		var y = bounds.minY
		var rowHeight: CGFloat = 0

		for subview in subviews {
			let size = subview.sizeThatFits(.unspecified)
			if x + size.width > bounds.maxX {
				x = bounds.minX
				y += rowHeight + verticalSpacing
				rowHeight = 0
			}

			subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(width: size.width, height: size.height))
			rowHeight = max(rowHeight, size.height)
			x += size.width + horizontalSpacing
		}
	}
}
