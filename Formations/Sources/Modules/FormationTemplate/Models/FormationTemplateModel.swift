// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class FormationTemplateModel: RealmModel<FormationTemplate>, IdentifierGeneratable {
    
    override func create() -> Entity {
        let ret = super.create()
        ret.id = generateIdentifier()
        return ret
    }
}

extension Realm {
    static let FormationTemplate = FormationTemplateModel()
}
