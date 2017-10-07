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
    
    /// アイテム
    let items = List<FormationTemplateItem>()
        
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["percentages"]
    }
}
