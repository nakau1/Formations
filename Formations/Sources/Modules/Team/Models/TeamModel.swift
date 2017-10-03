// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class TeamModel: RealmModel<Team>, IdentifierGeneratable {
	
    override func create() -> Entity {
        let ret = super.create()
        ret.id = generateIdentifier()
        return ret
    }
    
    override func save(entities: [Entity]) {
        super.save(entities: entities)
        saveImages(entities: entities)
    }
    
    override func update(_ condition: NSPredicate? = nil, updating: (Entity, Int) -> Void) {
        super.update(condition, updating: updating)
        saveImages(entities: select(condition).toArray())
    }
    
    override func delete(_ condition: NSPredicate? = nil) {
        super.delete(condition)
        deleteImages(entities: select(condition).toArray())
    }
    
    private func saveImages(entities: [Entity]) {
        entities.forEach { entity in
            let emblemImage = entity.loadEmblemImage().emblemImage?.adjusted(to: CGSize(400, 400), shouldExpand: true)
            Image.teamEmblem(id: entity.id).save(emblemImage)
            
            let smallEmblemImage = entity.loadSmallEmblemImage().smallEmblemImage?.adjusted(to: CGSize(210, 210), shouldExpand: true)
            Image.teamSmallEmblem(id: entity.id).save(smallEmblemImage)
            
            let teamImage = entity.loadTeamImage().teamImage?.adjusted(to: CGSize(828, 1472), shouldExpand: true)
            Image.teamImage(id: entity.id).save(teamImage)
        }
    }
    
    private func deleteImages(entities: [Entity]) {
        entities.forEach { entity in
            Image.delete(category: .teams, id: entity.id)
        }
    }
}

extension Realm {
    static let Team = TeamModel()
}
