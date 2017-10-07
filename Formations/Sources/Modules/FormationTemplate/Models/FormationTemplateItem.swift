// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class FormationTemplateItem: RealmSwift.Object {
    
    var info = [String : Any?]()
    
    // MARK: - Properties
    
    /// ソート順
    @objc dynamic var number = 1
    
    // パーセンテージ
    @objc dynamic var xPercentage: Float = 0.0
    @objc dynamic var yPercentage: Float = 0.0
    
    // ポジション
    @objc dynamic var positionText: String = "MF"
    
    var percentage: CGPercentage {
        get {
            return CGPercentage(xPercentage.f, yPercentage.f)
        }
        set {
            xPercentage = Float(newValue.x)
            yPercentage = Float(newValue.y)
        }
    }
    
    var position: Position {
        get {
            return Position(rawValue: positionText)!
        }
        set {
            positionText = newValue.rawValue
        }
    }
    
    override class func ignoredProperties() -> [String] {
        return ["percentage", "position", "info"]
    }
}
