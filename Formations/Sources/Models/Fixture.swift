// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift
import Rswift

class Fixture {
    
    static let shared = Fixture()
    private init() {}
    
    func fix() {
        let team = makeTeam()
        
        let players = makePlayers()
        players.forEach {
            Realm.Player.save($0)
            team.players.append($0)
        }
        
        let formationTemplates = makeFormationTemplates()
        formationTemplates.forEach {
            Realm.FormationTemplate.save($0)
            team.formationTemplates.append($0)
        }
        
        Realm.Team.save(team)
    }
    
    func reset() {
        Realm.Team.delete()
        Realm.Player.delete()
        Realm.FormationTemplate.delete()
        Realm.Formation.delete()
        Image.deleteAll()
    }
}

private extension Fixture {
    
    func makeTeam() -> Team {
        let team = Realm.Team.create()
        team.name = "ガンバ大阪"
        team.internationalName = "Gamba Osaka"
        team.shortenedName = "GMB"
        
        team.emblemImage      = UIImage(named: "team-sample-emblem")
        team.smallEmblemImage = UIImage(named: "team-sample-emblem")
        team.teamImage        = UIImage(named: "team-sample-image")
        
        return team
    }
    
    func makePlayers() -> [Player] {
        return NSArray(contentsOfFile: R.file.dataPlist.path()!)!.map { e -> Player in
            let elem = e as! [String : String]
            let player = Realm.Player.create()
            
            player.name              = elem["name"]!
            player.familyName        = elem["familyName"]!
            player.internationalName = elem["internationalName"]!
            player.shortenedName     = elem["shortenedName"]!
            player.uniformNumber     = elem["uniformNumber"]!
            player.positionText      = elem["positionText"]!
            
            player.faceImage  = UIImage(named: "player-sample\(player.uniformNumber)-1.jpg")
            player.thumbImage = UIImage(named: "player-sample\(player.uniformNumber)-1.jpg")
            player.fullImage  = UIImage(named: "player-sample\(player.uniformNumber)-2.jpg")
            
            return player
        }
    }
    
    func makeFormationTemplates() -> [FormationTemplate] {
        return []
    }
}
