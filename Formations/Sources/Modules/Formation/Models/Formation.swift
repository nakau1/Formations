// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class Formation: Codable {
    
    class MemberedPlayer: Codable {
        
        var playerID = "" // of Player Entity
        
        var name = ""
        
        var familyName = ""
        
        var internationalName = ""
        
        var shortenedName = ""
        
        var uniformNumber = ""
        
        var positionColorRGB = ""
    }
    
    class PositionedPlayer: Codable {
        
        var x: CGFloat = 0
        
        var y: CGFloat = 0
        
        var positionColorRGB = ""
        
        var memberedPlayer: Formation.MemberedPlayer?
    }
    
    var name = ""
    
    var numberOfSubstitutes = 7
    
    var startingMembers: [Formation.PositionedPlayer]!
    
    var substituteMembers = [Formation.MemberedPlayer]()
    
    init() {
        self.startingMembers = FormationTemplatePreInstalledData().defaultItems.map { item -> Formation.PositionedPlayer in
            return self.convertToPositionedPlayer(byItem: item, player: nil)
        }
    }
}

extension Formation {
    
    func updateTemplate(_ template: FormationTemplate) {
        startingMembers.enumerated().forEach { i, member in
            let item = template.items[i]
            member.update(byFormationTemplateItem: item)
        }
    }
    
    func updatePercentage(_ percentage: CGPercentage, at index: Int) {
        if let member = startingMembers.get(index) {
            member.x = percentage.x
            member.y = percentage.y
        }
    }
    
    func updateStartingMember(to player: Player, at index: Int) {
        if let member = startingMembers.get(index) {
            member.memberedPlayer = convertToMemberedPlayer(byPlayer: player)
        }
    }
}

extension Formation.MemberedPlayer {
    
    var displayingName: String {
        return "\(uniformNumber) \(familyName)"
    }
    
    var thumbImage: UIImage? {
        return Image.playerThumb(id: self.playerID).load()
    }
    
    var positionColor: UIColor {
        return UIColor(hexString: self.positionColorRGB) ?? .gray
    }
    
    func update(byPlayer player: Player) {
        self.playerID          = player.id
        self.name              = player.name
        self.familyName        = player.familyName
        self.internationalName = player.internationalName
        self.shortenedName     = player.shortenedName
        self.uniformNumber     = player.uniformNumber
        self.positionColorRGB  = player.position.backgroundColor.hexString
    }
}

extension Formation.PositionedPlayer {
    
    var displayingName: String {
        return memberedPlayer?.displayingName ?? ""
    }
    
    var percentage: CGPercentage {
        get {
            return CGPercentage(self.x, self.y)
        }
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    var positionColor: UIColor {
        return UIColor(hexString: self.positionColorRGB) ?? .gray
    }
    
    func update(byFormationTemplateItem item: FormationTemplateItem) {
        self.x = item.xPercentage.f
        self.y = item.yPercentage.f
        self.positionColorRGB = item.position.backgroundColor.hexString
    }
}

extension Formation {
    
    private func convertToPositionedPlayer(byItem item: FormationTemplateItem?, player: Player?) -> Formation.PositionedPlayer {
        let ret = Formation.PositionedPlayer()
        if let item = item {
            ret.update(byFormationTemplateItem: item)
        }
        if let player = player {
            ret.memberedPlayer = self.convertToMemberedPlayer(byPlayer: player)
        }
        return ret
    }
    
    private func convertToMemberedPlayer(byPlayer player: Player?) -> Formation.MemberedPlayer {
        let ret = Formation.MemberedPlayer()
        if let player = player {
            ret.update(byPlayer: player)
        }
        return ret
    }
}
