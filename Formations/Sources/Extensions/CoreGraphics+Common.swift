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
        self.init(origin: size.center(of: parentSize), size: size)
	}
	
	init(width: CGFloat, height: CGFloat) {
		self.init(size: CGSize(width, height))
	}
}

extension CGPoint {
	
	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x - rhs.x, lhs.y - rhs.y)
    }
}

extension CGSize {
	
	init(_ width: CGFloat, _ height: CGFloat) {
		self.init(width: width, height: height)
	}
    
    func center(of size: CGSize) -> CGPoint {
        return CGPoint(
            x: (size.width  - self.width)  / 2,
            y: (size.height - self.height) / 2
        )
    }
	
	static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(lhs.width * rhs, lhs.height * rhs)
	}
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(lhs.width + rhs.width, lhs.height + rhs.height)
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(lhs.width - rhs.width, lhs.height - rhs.height)
    }
}

struct CGPercentage: Comparable {
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    init() {}
    
    init(x: CGFloat, y: CGFloat) {
        self.x = (0 <= x) ? ((x < 1.f) ? x : 1.f) : 0.f
        self.y = (0 <= y) ? ((y < 1.f) ? y : 1.f) : 0.f
    }
    
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    
    static func *(lhs: CGPoint, rhs: CGPercentage) -> CGPoint {
        return CGPoint(lhs.x * rhs.x, lhs.y * rhs.y)
    }
    
    static func *(lhs: CGSize, rhs: CGPercentage) -> CGSize {
        return CGSize(lhs.width * rhs.x, lhs.height * rhs.y)
    }
    
    static func ==(lhs: CGPercentage, rhs: CGPercentage) -> Bool {
        return lhs.y == rhs.y && lhs.x == rhs.x
    }
    
    static func <(lhs: CGPercentage, rhs: CGPercentage) -> Bool {
        return (lhs.y < rhs.y) || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
    
    static func <=(lhs: CGPercentage, rhs: CGPercentage) -> Bool {
        return (lhs.y <= rhs.y) || (lhs.y == rhs.y && lhs.x <= rhs.x)
    }
    
    static func >=(lhs: CGPercentage, rhs: CGPercentage) -> Bool {
        return (lhs.y >= rhs.y) || (lhs.y == rhs.y && lhs.x >= rhs.x)
    }
    
    static func >(lhs: CGPercentage, rhs: CGPercentage) -> Bool {
        return (lhs.y > rhs.y) || (lhs.y == rhs.y && lhs.x > rhs.x)
    }
}

extension CGFloat {
    
    var int: Int {
        return Int(self)
    }
    
    static func %(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
        return (lhs.int % rhs.int).f
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
