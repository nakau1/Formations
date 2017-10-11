// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class FormationModel: IdentifierGeneratable {
    
    func create() -> Formation {
        let ret = Formation()
        //ret.id = generateIdentifier()
        return ret
    }
}

extension Realm {
    static let Formation = FormationModel()
}
