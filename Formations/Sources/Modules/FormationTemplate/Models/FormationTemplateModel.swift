// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class FormationTemplateModel: RealmModel<FormationTemplate>, IdentifierGeneratable {
    
    override func create() -> Entity {
        let ret = super.create()
        ret.id = generateIdentifier()
        ret.items.append(objectsIn: createDefaultItems())
        return ret
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

extension Realm {
    static let FormationTemplate = FormationTemplateModel()
}
