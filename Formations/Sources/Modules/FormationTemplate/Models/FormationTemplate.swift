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
    @objc dynamic var name = "4-4-2"
    
    /// アイテム
    let items = List<FormationTemplateItem>()
    
    // MARK: - Images
    
    /// 一覧用画像
    var image: UIImage?
    
    func loadImage(force: Bool = false) -> Self {
        if image == nil || force {
            image = Image.formationTemplate(id: id).load()
        }
        return self
    }
    
    /// 人数構成
    var structure: [Position : Int] {
        get {
            let ret: [Position : Int] = [
                .goalKeeper : 0,
                .defender   : 0,
                .midfielder : 0,
                .forward    : 0,
                ]
            return items.reduce(into: ret) { res, item in
                res[item.position] = res[item.position, default: 0] + 1
            }
        }
        set {
            var positions = [Position]()
            (0..<newValue[.forward]!)   .forEach { _ in positions.append(.forward) }
            (0..<newValue[.midfielder]!).forEach { _ in positions.append(.midfielder) }
            (0..<newValue[.defender]!)  .forEach { _ in positions.append(.defender) }
            positions.append(.goalKeeper)
            
            let newItems = items
            .sorted { a, b in
                return a.percentage < b.percentage
            }
            .enumerated().map { i, datum -> FormationTemplateItem in
                let item = FormationTemplateItem()
                item.percentage = datum.percentage
                item.position   = positions[i]
                item.number     = i
                return item
            }
            
            items.removeAll()
            items.append(objectsIn: newItems)
        }
    }
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["image", "structure", "info"]
    }
}
