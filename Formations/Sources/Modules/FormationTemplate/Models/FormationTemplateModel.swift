// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class FormationTemplateModel: RealmModel<FormationTemplate>, IdentifierGeneratable {
    
    static let maxlenOfName = 15
    
    override func create() -> Entity {
        let preinstall = FormationTemplatePreInstalledData()
        let ret = super.create()
        ret.id = generateIdentifier()
        ret.items.append(objectsIn: preinstall.defaultItems)
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
            Image.formationTemplate(id: entity.id).save(UIImage(template: entity))
        }
    }
    
    private func deleteImages(entities: [Entity]) {
        entities.forEach { entity in
            Image.delete(category: .formationTemplates, id: entity.id)
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

// MARK: - Image

extension UIImage {
    
    convenience init(template: FormationTemplate) {
        let imageSize = CGSize(600, 480)
        let pinWidth = 32.f
        let baseImage = R.image.formationTemplateBg()!.scaled(to: imageSize)
        let pinsImage = UIImage.imageFromContext(imageSize) { context in
            let maxPoint = CGPoint(imageSize.width - pinWidth, imageSize.height - pinWidth)
            template.items.forEach { item in
                let center = (maxPoint * item.percentage) + CGPoint(pinWidth / 2, pinWidth / 2)
                let size = CGSize(square: pinWidth)
                let rect = CGRect(origin: center, size: size)
                
                context.saveGState()
                context.setFillColor(item.position.backgroundColor.cgColor)
                context.fillEllipse(in: rect)
                context.restoreGState()
            }
        }
        self.init(cgImage: baseImage.synthesized(image: pinsImage).cgImage!)
    }
}
