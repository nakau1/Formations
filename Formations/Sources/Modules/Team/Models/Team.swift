// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class Team: RealmSwift.Object {
    
    // MARK: - Properties
    
    /// ID
    @objc dynamic var id = ""
    
    /// チーム名
    @objc dynamic var name = ""
    /// チーム名(国際名)
    @objc dynamic var internationalName = ""
    /// チーム名(短縮系)
    @objc dynamic var shortenedName = ""
    
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
    
    func loadEmblemImage() -> Self {
        if emblemImage == nil {
            emblemImage = Image.teamEmblem(id: id).load()
        }
        return self
    }
    
    /// エンブレム(小)画像
    var smallEmblemImage: UIImage?
    
    func loadSmallEmblemImage() -> Self {
        if smallEmblemImage == nil {
            smallEmblemImage = Image.teamSmallEmblem(id: id).load()
        }
        return self
    }
    
    /// チーム画像(背景用)
    var teamImage: UIImage?
    
    func loadTeamImage() -> Self {
        if teamImage == nil {
            teamImage = Image.teamImage(id: id).load()
        }
        return self
    }
    
    // MARK: - Calculated Properties
    
    /// チームカラー(メイン)
    var mainColor: UIColor {
        return UIColor.blue
    }
    
    /// チームカラー(サブ)
    var subColor: UIColor {
        return UIColor.blue
    }
    
    /// チームカラー(オプション1)
    var option1Color: UIColor {
        return UIColor.blue
    }
    
    /// チームカラー(オプション2)
    var option2Color: UIColor {
        return UIColor.blue
    }
    
    // MARK: - Specs
    
    override class func primaryKey() -> String? { return "id" }
    
    override class func ignoredProperties() -> [String] {
        return ["emblemImage", "smallEmblemImage", "teamImage"]
    }
    
    override var description: String {
        return "\(name) <\(internationalName)>"
    }
}
