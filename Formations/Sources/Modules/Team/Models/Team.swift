// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class Team: RealmSwift.Object {
    
    var info = [String : Any?]()
    
    // MARK: - Properties
    
    /// ID
    @objc dynamic var id = ""
    
    /// チーム名
    @objc dynamic var name = "新しいクラブ"
    /// チーム名(国際名)
    @objc dynamic var internationalName = "Formation FC"
    /// チーム名(短縮系)
    @objc dynamic var shortenedName = "FFC"
    
    /// チームカラー(メイン)RGB値
    @objc dynamic var mainColorRGB = ""
    /// チームカラー(サブ)RGB値
    @objc dynamic var subColorRGB = ""
    /// チームカラー(オプション1)RGB値
    @objc dynamic var option1ColorRGB = ""
    /// チームカラー(オプション2)RGB値
    @objc dynamic var option2ColorRGB = ""
    
    /// 所属選手
    let players = List<Player>()
    /// フォーメーション雛形
    let formationTemplates = List<FormationTemplate>()
    /// フォーメーション
    let formations = List<Formation>()
    
    // MARK: - Images
    
    /// エンブレム(オリジナル)画像
    var emblemImage: UIImage?
    
    func loadEmblemImage(force: Bool = false) -> Self {
        if emblemImage == nil || force {
            emblemImage = Image.teamEmblem(id: id).load()
        }
        return self
    }
    
    /// エンブレム(小)画像
    var smallEmblemImage: UIImage?
    
    func loadSmallEmblemImage(force: Bool = false) -> Self {
        if smallEmblemImage == nil || force {
            smallEmblemImage = Image.teamSmallEmblem(id: id).load()?.retina
        }
        return self
    }
    
    /// チーム画像(背景用)
    var teamImage: UIImage?
    
    func loadTeamImage(force: Bool = false) -> Self {
        if teamImage == nil || force {
            teamImage = Image.teamImage(id: id).load()
        }
        return self
    }
    
    // MARK: - Calculated Properties
    
    /// チームカラー(メイン)
    var mainColor: UIColor {
        get {
            return UIColor(hexString: mainColorRGB) ?? .white
        }
        set {
            return mainColorRGB = newValue.hexString
        }
    }
    
    /// チームカラー(サブ)
    var subColor: UIColor {
        get {
            return UIColor(hexString: subColorRGB) ?? .white
        }
        set {
            return subColorRGB = newValue.hexString
        }
    }
    
    /// チームカラー(オプション1)
    var option1Color: UIColor? {
        get {
            return UIColor(hexString: option1ColorRGB)
        }
        set {
            guard let color = newValue else {
                option1ColorRGB = ""
                return
            }
            return option1ColorRGB = color.hexString
        }
    }
    
    /// チームカラー(オプション2)
    var option2Color: UIColor? {
        get {
            return UIColor(hexString: option2ColorRGB)
        }
        set {
            guard let color = newValue else {
                option2ColorRGB = ""
                return
            }
            return option2ColorRGB = color.hexString
        }
    }
    
    // MARK: - Specs
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["emblemImage", "smallEmblemImage", "teamImage", "info"]
    }
    
    override var description: String {
        return "\(name) <\(internationalName)>"
    }
}
