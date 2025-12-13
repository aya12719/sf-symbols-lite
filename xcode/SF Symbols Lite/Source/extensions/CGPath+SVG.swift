import CoreGraphics
import Foundation

extension CGPath {

	private func fmt(_ v: CGFloat) -> String { String(format: "%g", v) }

	var svg: String {
		var d = ""
		applyWithBlock { e in
			let e = e.pointee
			switch e.type {
			case .moveToPoint:
				d += "M \(fmt(e.points[0].x)) \(fmt(e.points[0].y)) "
			case .addLineToPoint:
				d += "L \(fmt(e.points[0].x)) \(fmt(e.points[0].y)) "
			case .addQuadCurveToPoint:
				d += "Q \(fmt(e.points[0].x)) \(fmt(e.points[0].y)) \(fmt(e.points[1].x)) \(fmt(e.points[1].y)) "
			case .addCurveToPoint:
				d += "C \(fmt(e.points[0].x)) \(fmt(e.points[0].y)) \(fmt(e.points[1].x)) \(fmt(e.points[1].y)) \(fmt(e.points[2].x)) \(fmt(e.points[2].y)) "
			case .closeSubpath:
				d += "Z "
			@unknown default: break
			}
		}
		return d.trimmingCharacters(in: .whitespaces)
	}
}
