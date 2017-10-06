// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class Player: RealmSwift.Object {
    
    var info = [String : Any?]()
    
    // MARK: - Properties
    
    /// ID
    @objc dynamic var id = ""
    
    /// 選手名(フルネーム)
    @objc dynamic var name = ""
    /// 選手名(名字)
    @objc dynamic var familyName = ""
    /// 選手名(国際名)
    @objc dynamic var internationalName = ""
    /// 選手名(国際短縮名)
    @objc dynamic var shortenedName = ""
    
    /// 背番号(基本的には数字だがイレギュラーを見越して文字列型)
    @objc dynamic var uniformNumber = ""
    /// ポジション
    @objc dynamic var positionText = "MF"
    
    // MARK: -
    
    /// ポジション
    var position: Position {
        return Position(rawValue: positionText)!
    }
    
    // MARK: - Images
    
    /// 顔画像
    var faceImage: UIImage?
    
    func loadFaceImage(force: Bool = false) -> Self {
        if faceImage == nil || force {
            faceImage = Image.playerFace(id: id).load()
        }
        return self
    }
    
    /// サムネイル画像
    var thumbImage: UIImage?
    
    func loadThumbImage(force: Bool = false) -> Self {
        if thumbImage == nil || force {
            thumbImage = Image.playerThumb(id: id).load()
        }
        return self
    }
    /// 全身画像
    var fullImage: UIImage?
    
    func loadFullImage(force: Bool = false) -> Self {
        if fullImage == nil || force {
            fullImage = Image.playerThumb(id: id).load()
        }
        return self
    }
    
    // MARK: - Specs
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["faceImage", "thumbImage", "fullImage", "position", "info"]
    }
    
    override var description: String {
        return "\(positionText)\(uniformNumber) \(name) <\(internationalName)>"
    }
}
