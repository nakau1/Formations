// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class TeamModel: RealmModel<Team>, IdentifierGeneratable {
    
    static let maxlenOfName = 30
    static let maxlenOfInternationalName = 30
    static let fixlenOfShortenedName = 3
	
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
            
            let smallEmblemImage = entity.loadSmallEmblemImage().smallEmblemImage?.adjusted(to: CGSize(273, 273), shouldExpand: true)
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

extension TeamModel {
    
    enum ValidateTarget: String {
        case name, internationalName, shortenedName
        
        var key: String {
            return "validation.result." + self.rawValue
        }
    }
    
    func clearValidateResults(_ entity: Entity) {
        let targets: [ValidateTarget] = [.name, .internationalName, .shortenedName]
        targets.forEach {
            entity.info[$0.key] = nil
        }
    }
    
    func validateName(_ name: String, of entity: Entity) -> Bool {
        let key = ValidateTarget.name.key
        entity.info[key] = nil
        
        if name.isEmpty {
            entity.info[key] = "必ず入力してください"
        } else if name.count > TeamModel.maxlenOfName {
            entity.info[key] = "\(TeamModel.maxlenOfName)字以内で入力してください"
        }
        return entity.info[key] == nil
    }
    
    func validateInternationalName(_ name: String, of entity: Entity) -> Bool {
        let key = ValidateTarget.internationalName.key
        entity.info[key] = nil
        
        if name.isEmpty {
            entity.info[key] = "必ず入力してください"
        } else if name.count > TeamModel.maxlenOfInternationalName {
            entity.info[key] = "\(TeamModel.maxlenOfInternationalName)字以内で入力してください"
        } else if !name.isOnlyAlphabetNumberHyphenWhitespace {
            entity.info[key] = "半角英数字(ハイフン可)のみで入力してください"
        }
        return entity.info[key] == nil
    }
    
    func validateShortenedName(_ name: String, of entity: Entity) -> Bool {
        let key = ValidateTarget.shortenedName.key
        entity.info[key] = nil
        
        if name.isEmpty {
            entity.info[key] = "必ず入力してください"
        } else if name.count != TeamModel.fixlenOfShortenedName {
            entity.info[key] = "\(TeamModel.fixlenOfShortenedName)字で入力してください"
        } else if !name.isOnlyAlphabet {
            entity.info[key] = "アルファベットのみで入力してください"
        }
        return entity.info[key] == nil
    }
    
    func validateResultOfName(_ entity: Entity) -> String {
        return entity.info[ValidateTarget.name.key] as? String ?? ""
    }
    
    func validateResultOfInternationalName(_ entity: Entity) -> String {
        return entity.info[ValidateTarget.internationalName.key] as? String ?? ""
    }
    
    func validateResultOfShortenedName(_ entity: Entity) -> String {
        return entity.info[ValidateTarget.shortenedName.key] as? String ?? ""
    }
}

extension Realm {
    static let Team = TeamModel()
}
