// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

class FormationModel {
    
    typealias Entity = Formation
    
    // MARK: - CRUD
    
    func create() -> Entity {
        return Entity()
    }
    
    func load(teamID id: String) -> Entity {
        guard let jsonString = Json.formation(teamId: id).load() else {
            return create()
        }
        return try! JSONDecoder().decode(Formation.self, from: jsonString.data(using: .utf8)!)
    }
    
    func save(entity: Entity, toTeamID id: String) {
        let data = try! JSONEncoder().encode(entity)
        let jsonString = String(data: data, encoding: .utf8)
        Json.formation(teamId: id).save(jsonString)
    }
    
    func delete(teamID id: String) {
        Json.formation(teamId: id).delete()
    }
}

extension Realm {
    static let Formation = FormationModel()
}
