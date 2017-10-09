// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class FormationTemplateModel: RealmModel<FormationTemplate>, IdentifierGeneratable {
    
    static let maxlenOfName = 15
    
    override func create() -> Entity {
        let ret = super.create()
        ret.id = generateIdentifier()
        ret.items.append(objectsIn: createDefaultItems())
        return ret
    }
    
    override func save(entities: [Entity]) {
        super.save(entities: entities)
        saveImages(entities: entities)
    }
    
    override func delete(_ condition: NSPredicate? = nil) {
        super.delete(condition)
        deleteImages(entities: select(condition).toArray())
    }
    
    private func saveImages(entities: [Entity]) {
        entities.forEach { entity in
            let imageCreator = FormationTemplateImageCreator()
            let image = imageCreator.create(template: entity)
            Image.formationTemplate(id: entity.id).save(image)
        }
    }
    
    private func deleteImages(entities: [Entity]) {
        entities.forEach { entity in
            Image.delete(category: .formationTemplates, id: entity.id)
        }
    }
}

// MARK: - FormationTemplateItem
extension FormationTemplateModel {
    
    func createDefaultItems() -> [FormationTemplateItem] {
        let data: [(percentage: CGPercentage, position: Position)] = [
            (percentage: CGPercentage(0.358, 0.041), position: .forward),
            (percentage: CGPercentage(0.632, 0.041), position: .forward),
            (percentage: CGPercentage(0.500, 0.242), position: .midfielder),
            (percentage: CGPercentage(0.246, 0.373), position: .midfielder),
            (percentage: CGPercentage(0.773, 0.373), position: .midfielder),
            (percentage: CGPercentage(0.500, 0.525), position: .midfielder),
            (percentage: CGPercentage(0.069, 0.568), position: .defender),
            (percentage: CGPercentage(0.934, 0.568), position: .defender),
            (percentage: CGPercentage(0.318, 0.732), position: .defender),
            (percentage: CGPercentage(0.678, 0.732), position: .defender),
            (percentage: CGPercentage(0.500, 0.920), position: .goalKeeper),
        ]
        return data.enumerated().map { i, datum -> FormationTemplateItem in
            let item = FormationTemplateItem()
            item.percentage = datum.percentage
            item.position   = datum.position
            item.number     = i
            return item
        }
    }
}

// MARK: - Validation
extension FormationTemplateModel {
    
    enum ValidateTarget: String {
        case name
        
        var key: String {
            return "validation.result." + self.rawValue
        }
    }
    
    func clearValidateResults(_ entity: Entity) {
        let targets: [ValidateTarget] = [.name]
        targets.forEach {
            entity.info[$0.key] = nil
        }
    }
    
    func validateName(_ name: String, of entity: Entity) -> Bool {
        let key = ValidateTarget.name.key
        entity.info[key] = nil
        
        if name.count > FormationTemplateModel.maxlenOfName {
            entity.info[key] = "\(FormationTemplateModel.maxlenOfName)字以内で入力してください"
        }
        return entity.info[key] == nil
    }
    
    func validateResultOfName(_ entity: Entity) -> String {
        return entity.info[ValidateTarget.name.key] as? String ?? ""
    }
}

// MARK: - Notification
extension FormationTemplateModel {
    
    func observe(_ observer: Any, change selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .FormationTemplateDidChange, object: nil)
    }
    
    func notifyChange() {
        NotificationCenter.default.post(name: .FormationTemplateDidChange, object: nil)
    }
}

extension Notification.Name {
    static let FormationTemplateDidChange = Notification.Name("FormationTemplateDidChange")
}

extension Realm {
    static let FormationTemplate = FormationTemplateModel()
}
