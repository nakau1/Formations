// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class PlayerModel: RealmModel<Player>, IdentifierGeneratable {
    
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
            let faceImage = entity.loadFaceImage().faceImage?.adjusted(to: CGSize(280, 280), shouldExpand: true)
            Image.playerFace(id: entity.id).save(faceImage)
            
            let thumbImage = entity.loadThumbImage().thumbImage?.adjusted(to: CGSize(150, 150), shouldExpand: true)
            Image.playerThumb(id: entity.id).save(thumbImage)
            
            let fullImage = entity.loadFullImage().fullImage?.adjusted(to: CGSize(310, 414), shouldExpand: true)
            Image.playerFull(id: entity.id).save(fullImage)
        }
    }
    
    private func deleteImages(entities: [Entity]) {
        entities.forEach { entity in
            Image.delete(category: .players, id: entity.id)
        }
    }
}

extension Realm {
    static let Player = PlayerModel()
}
