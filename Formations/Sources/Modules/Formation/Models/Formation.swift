// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class Formation: Codable {
    
    class Player: Codable {
        
        var playerID = ""
        
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
        
        var position: CGFloat = 0
        
        var player: Formation.Player!
    }
    
    var name = ""
    
    var numberOfSubstitutes = 7
    
    var startingMembers: [Formation.PositionedPlayer]!
    
    var substituteMembers: [Formation.Player]!
    
    init() {
        self.startingMembers = (0..<11).map { _ in
            return Formation.PositionedPlayer()
        }
        self.substituteMembers = (0..<self.numberOfSubstitutes).map { _ in
            return Formation.Player()
        }
    }
}
