// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

extension UIColor {
    
    convenience init?(hexString: String?) {
        guard let hexString = hexString, !hexString.isEmpty else {
            return nil
        }
        
        var color: UInt32 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        if Scanner(string: hexString).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000)   >> 16) / 255
            g = CGFloat((color & 0x00FF00)   >>  8) / 255
            b = CGFloat( color & 0x0000FF         ) / 255
        }
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    var hexString: String {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return [r,g,b].reduce("") { res, value in
            let intval = Int(round(value * 255))
            return res + (NSString(format: "%02X", intval) as String)
        }
    }
}
