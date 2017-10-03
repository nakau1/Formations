// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class TeamModel: RealmModel<Team>, IdentifierGeneratable {
	
    override func create() -> Entity {
        let ret = super.create()
        ret.id = generateIdentifier()
        return ret
    }
}

extension Realm {
    static let Team = TeamModel()
}
