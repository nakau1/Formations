// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class FormationTemplate: RealmSwift.Object {
    
    var info = [String : Any?]()
    
    // MARK: - Properties
    
    /// ID
    @objc dynamic var id = ""
    
    /// ソート順
    @objc dynamic var sortNumber = 0
    
    /// 名称
    @objc dynamic var name = ""
    
    /// 概要
    @objc dynamic var summery = ""
    
    // ポジション
    @objc dynamic var perc1X:  Float = 0.0
    @objc dynamic var perc2X:  Float = 0.0
    @objc dynamic var perc3X:  Float = 0.0
    @objc dynamic var perc4X:  Float = 0.0
    @objc dynamic var perc5X:  Float = 0.0
    @objc dynamic var perc6X:  Float = 0.0
    @objc dynamic var perc7X:  Float = 0.0
    @objc dynamic var perc8X:  Float = 0.0
    @objc dynamic var perc9X:  Float = 0.0
    @objc dynamic var perc10X: Float = 0.0
    @objc dynamic var perc11X: Float = 0.0
    
    @objc dynamic var perc1Y:  Float = 0.0
    @objc dynamic var perc2Y:  Float = 0.0
    @objc dynamic var perc3Y:  Float = 0.0
    @objc dynamic var perc4Y:  Float = 0.0
    @objc dynamic var perc5Y:  Float = 0.0
    @objc dynamic var perc6Y:  Float = 0.0
    @objc dynamic var perc7Y:  Float = 0.0
    @objc dynamic var perc8Y:  Float = 0.0
    @objc dynamic var perc9Y:  Float = 0.0
    @objc dynamic var perc10Y: Float = 0.0
    @objc dynamic var perc11Y: Float = 0.0
    
    var percentages: [CGPercentage] {
        get {
            return (1...11).map { percentage(at: $0) }
        }
        set(v) {
            if v.count != 11 { return }
            v.enumerated().forEach { i, percentage in
                setPercentage(percentage, at: i+1)
            }
        }
    }
    
    func percentage(at number: Int) -> CGPercentage {
        return CGPercentage(x(at: number), y(at: number))
    }
    
    func setPercentage(_ percentage: CGPercentage, at number: Int) {
        switch number {
        case 1:  perc1X  = Float(percentage.x); perc1Y  = Float(percentage.y)
        case 2:  perc2X  = Float(percentage.x); perc2Y  = Float(percentage.y)
        case 3:  perc3X  = Float(percentage.x); perc3Y  = Float(percentage.y)
        case 4:  perc4X  = Float(percentage.x); perc4Y  = Float(percentage.y)
        case 5:  perc5X  = Float(percentage.x); perc5Y  = Float(percentage.y)
        case 6:  perc6X  = Float(percentage.x); perc6Y  = Float(percentage.y)
        case 7:  perc7X  = Float(percentage.x); perc7Y  = Float(percentage.y)
        case 8:  perc8X  = Float(percentage.x); perc8Y  = Float(percentage.y)
        case 9:  perc9X  = Float(percentage.x); perc9Y  = Float(percentage.y)
        case 10: perc10X = Float(percentage.x); perc10Y = Float(percentage.y)
        case 11: perc11X = Float(percentage.x); perc11Y = Float(percentage.y)
        default: break
        }
    }
    
    func x(at number: Int) -> CGFloat {
        switch number {
        case 1:  return CGFloat(perc1X)
        case 2:  return CGFloat(perc2X)
        case 3:  return CGFloat(perc3X)
        case 4:  return CGFloat(perc4X)
        case 5:  return CGFloat(perc5X)
        case 6:  return CGFloat(perc6X)
        case 7:  return CGFloat(perc7X)
        case 8:  return CGFloat(perc8X)
        case 9:  return CGFloat(perc9X)
        case 10: return CGFloat(perc10X)
        case 11: return CGFloat(perc11X)
        default: return 0
        }
    }
    
    func y(at number: Int) -> CGFloat {
        switch number {
        case 1:  return CGFloat(perc1Y)
        case 2:  return CGFloat(perc2Y)
        case 3:  return CGFloat(perc3Y)
        case 4:  return CGFloat(perc4Y)
        case 5:  return CGFloat(perc5Y)
        case 6:  return CGFloat(perc6Y)
        case 7:  return CGFloat(perc7Y)
        case 8:  return CGFloat(perc8Y)
        case 9:  return CGFloat(perc9Y)
        case 10: return CGFloat(perc10Y)
        case 11: return CGFloat(perc11Y)
        default: return 0
        }
    }
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["percentages"]
    }
}
