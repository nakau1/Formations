// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import CoreGraphics

class PlayerModel: RealmModel<Player>, IdentifierGeneratable {
	
	static let maxlenOfName = 30
	static let maxlenOfFamilyName = 30
	static let maxlenOfInternationalName = 30
	static let maxlenOfShortenedName = 3
    
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
			let faceImage = entity.loadFaceImage().faceImage
			Image.playerFace(id: entity.id).save(faceImage)
			
			let thumbImage = entity.loadThumbImage().thumbImage
			Image.playerThumb(id: entity.id).save(thumbImage)
			
			let fullImage = entity.loadFullImage().fullImage
			Image.playerFull(id: entity.id).save(fullImage)
			
//            let faceImage = entity.loadFaceImage().faceImage?.adjusted(to: CGSize(280, 280), shouldExpand: true)
//            Image.playerFace(id: entity.id).save(faceImage)
//
//            let thumbImage = entity.loadThumbImage().thumbImage?.adjusted(to: CGSize(150, 150), shouldExpand: true)
//            Image.playerThumb(id: entity.id).save(thumbImage)
//
//            let fullImage = entity.loadFullImage().fullImage?.adjusted(to: CGSize(310, 414), shouldExpand: true)
//            Image.playerFull(id: entity.id).save(fullImage)
        }
    }
    
    private func deleteImages(entities: [Entity]) {
        entities.forEach { entity in
            Image.delete(category: .players, id: entity.id)
        }
    }
}

// MARK: - Validation
extension PlayerModel {
	
	enum ValidateTarget: String {
		case name, familyName, internationalName, shortenedName
		
		var key: String {
			return "validation.result." + self.rawValue
		}
	}
	
	func clearValidateResults(_ entity: Entity) {
		let targets: [ValidateTarget] = [.name, .familyName, .internationalName, .shortenedName]
		targets.forEach {
			entity.info[$0.key] = nil
		}
	}
	
	func validateName(_ name: String, of entity: Entity) -> Bool {
		let key = ValidateTarget.name.key
		entity.info[key] = nil
		
		if name.isEmpty {
			entity.info[key] = "必ず入力してください"
		} else if name.count > PlayerModel.maxlenOfName {
			entity.info[key] = "\(PlayerModel.maxlenOfName)字以内で入力してください"
		}
		return entity.info[key] == nil
	}
	
	func validateFamilyName(_ name: String, of entity: Entity) -> Bool {
		let key = ValidateTarget.name.key
		entity.info[key] = nil
		
		if name.isEmpty {
			entity.info[key] = "必ず入力してください"
		} else if name.count > PlayerModel.maxlenOfFamilyName {
			entity.info[key] = "\(PlayerModel.maxlenOfFamilyName)字以内で入力してください"
		}
		return entity.info[key] == nil
	}
	
	func validateInternationalName(_ name: String, of entity: Entity) -> Bool {
		let key = ValidateTarget.internationalName.key
		entity.info[key] = nil
		
		if name.isEmpty {
			entity.info[key] = "必ず入力してください"
		} else if name.count > PlayerModel.maxlenOfInternationalName {
			entity.info[key] = "\(PlayerModel.maxlenOfInternationalName)字以内で入力してください"
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
		} else if name.count != PlayerModel.maxlenOfShortenedName {
			entity.info[key] = "\(PlayerModel.maxlenOfShortenedName)字で入力してください"
		} else if !name.isOnlyAlphabet {
			entity.info[key] = "アルファベットのみで入力してください"
		}
		return entity.info[key] == nil
	}
	
	func validateResultOfName(_ entity: Entity) -> String {
		return entity.info[ValidateTarget.name.key] as? String ?? ""
	}
	
	func validateResultOfFamilyName(_ entity: Entity) -> String {
		return entity.info[ValidateTarget.familyName.key] as? String ?? ""
	}
	
	func validateResultOfInternationalName(_ entity: Entity) -> String {
		return entity.info[ValidateTarget.internationalName.key] as? String ?? ""
	}
	
	func validateResultOfShortenedName(_ entity: Entity) -> String {
		return entity.info[ValidateTarget.shortenedName.key] as? String ?? ""
	}
}

// MARK: - Notification
extension PlayerModel {
	
	func observe(_ observer: Any, change selector: Selector) {
		NotificationCenter.default.addObserver(observer, selector: selector, name: .PlayerDidChange, object: nil)
	}
	
	func notifyChange() {
		NotificationCenter.default.post(name: .PlayerDidChange, object: nil)
	}
}

extension Notification.Name {
	static let PlayerDidChange = Notification.Name("PlayerDidChange")
}

extension Realm {
    static let Player = PlayerModel()
}
