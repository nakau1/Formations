// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import CoreGraphics

extension CGRect {
	
	init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
		self.init(x: x, y: y, width: width, height: height)
	}
	
	init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
	
	init(size: CGSize, centerOf parentSize: CGSize) {
		self.init(
			(parentSize.width - size.width) / 2,
			(parentSize.height - size.height) / 2,
			size.width,
			size.height
		)
	}
	
	init(width: CGFloat, height: CGFloat) {
		self.init(size: CGSize(width, height))
	}
}

extension CGPoint {
	
	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}
}

extension CGSize {
	
	init(_ width: CGFloat, _ height: CGFloat) {
		self.init(width: width, height: height)
	}
	
	static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(lhs.width * rhs, lhs.height * rhs)
	}
}

extension Int {
	
	var f: CGFloat {
		return CGFloat(self)
	}
}

extension Double {
	
	var f: CGFloat {
		return CGFloat(self)
	}
}

extension Float {
	
	var f: CGFloat {
		return CGFloat(self)
	}
}
