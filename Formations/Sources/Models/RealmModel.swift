// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation
import RealmSwift

class Realm {}

class RealmModel<T: RealmSwift.Object> {
    
    typealias Entity = T
    
    class var realmPath: String {
        return RealmSwift.Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
    }
    
    func loadRealm() -> RealmSwift.Realm {
        return try! RealmSwift.Realm()
    }
    
    // MARK: - CRUD
    
    func create() -> Entity {
        return Entity()
    }
    
    func write(_ entity: Entity, updating: (Entity) -> Void) {
        let realm = loadRealm()
        try! realm.write {
            updating(entity)
        }
    }
    
    func select(_ condition: NSPredicate? = nil) -> RealmSwift.Results<Entity> {
        if let conditionPredicate = condition {
            return loadRealm().objects(Entity.self).filter(conditionPredicate)
        } else {
            return loadRealm().objects(Entity.self)
        }
    }
    
    func count(_ condition: NSPredicate? = nil) -> Int {
        return select(condition).count
    }
    
    func save(entities: [Entity]) {
        let realm = loadRealm()
        try! realm.write {
            realm.add(entities, update: true)
        }
    }
    
    func save(_ entity: Entity) {
        save(entities: [entity])
    }
    
    func update(_ condition: NSPredicate? = nil, updating: (Entity, Int) -> Void) {
        let realm = loadRealm()
        try! realm.write {
            select(condition).enumerated().forEach { i, entity in
                updating(entity, i)
            }
        }
    }
    
    func delete(_ condition: NSPredicate? = nil) {
        let realm = loadRealm()
        try! realm.write {
            realm.delete(select(condition))
        }
    }
}

extension RealmSwift.Results {
    
    func toArray() -> [Element] {
        return self.map { $0 }
    }
}
