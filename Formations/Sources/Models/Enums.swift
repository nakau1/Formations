// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

/// ポジション
enum Position: String {
    case goalKeeper = "GK"
    case defender   = "DF"
    case midfielder = "MF"
    case forward    = "FW"
    
    var backgroundColor: UIColor {
        switch self {
        case .goalKeeper: return #colorLiteral(red: 0.8431372549, green: 0.6392156863, blue: 0.0862745098, alpha: 1)
        case .defender:   return #colorLiteral(red: 0.1921568627, green: 0.4, blue: 0.8588235294, alpha: 1)
        case .midfielder: return #colorLiteral(red: 0.3803921569, green: 0.6431372549, blue: 0.2823529412, alpha: 1)
        case .forward:    return #colorLiteral(red: 0.6823529412, green: 0.0862745098, blue: 0.1921568627, alpha: 1)
        }
    }
    
    static var items: [Position] {
        return [.goalKeeper, .defender, .midfielder, .forward]
    }
    
    static var texts: [String] {
        return items.map { $0.rawValue }
    }
}

/// 背番号
class UniformNumber {
    
    static var texts: [String] {
        var ret = (1...99).map { "\($0)" }
        ret.append("0")
        ret.append("00")
        ret.append("-")
        return ret
    }
}
