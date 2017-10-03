// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

enum Image {
    
    case playerFace(id: String)
    case playerThumb(id: String)
    case playerFull(id: String)
    case teamEmblem(id: String)
    case teamSmallEmblem(id: String)
    case teamImage(id: String)
    case test(id: String)
    case testOrigin(id: String)
    
    enum Category: String {
        case players
        case teams
        case formations
        case formationTemplates = "formation_templates"
        case test
    }

    var directory: String {
        switch self {
        case let .playerFace(id), let .playerThumb(id), let .playerFull(id):
            return "\(Category.players.rawValue)/\(id)"
        case let .teamEmblem(id), let .teamSmallEmblem(id), let .teamImage(id):
            return "\(Category.teams.rawValue)/\(id)"
        case .test, .testOrigin:
            return Category.test.rawValue
        }
    }
    
    var name: String {
        switch self {
        case .playerFace:         return "face"
        case .playerThumb:        return "thumb"
        case .playerFull:         return "full"
        case .teamEmblem:         return "emblem"
        case .teamSmallEmblem:    return "small_emblem"
        case .teamImage:          return "image"
        case let .test(id):       return id
        case let .testOrigin(id): return id + "_org"
        }
    }
    
    var extensionName: String {
        return "png"
    }
}

extension Image {
    
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    func save(_ image: UIImage?) {
        makeDirectoryIfNeeded()
        if let image = image {
            let data = UIImagePNGRepresentation(image)
            try? data?.write(to: URL(fileURLWithPath: path), options: [.atomic])
        } else {
            delete()
        }
    }
    
    func load() -> UIImage? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return UIImage(data: data)
    }
    
    func delete() {
        if exists {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
    
    static func delete(category: Category, id: String) {
        let components = [
            Image.documentDirectory,
            Image.resourceDirectory,
            category.rawValue,
            id,
            ]
        let path = components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
        if FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
    
    static func deleteAll() {
        let path = [Image.documentDirectory, Image.resourceDirectory].reduce("") {
            ($0 as NSString).appendingPathComponent($1)
        }
        if FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
    
    var path: String {
        let components = [
            Image.documentDirectory,
            Image.resourceDirectory,
            directory,
            "\(name).\(extensionName)"
        ]
        return components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
    }
    
    var directoryPath: String {
        let components = [
            Image.documentDirectory,
            Image.resourceDirectory,
            directory,
        ]
        return components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
    }
    
    static var resourceDirectory: String { return "resources" }
    
    static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    }
}

fileprivate extension Image {
    
    func makeDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: directoryPath) {
            try! FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
}

// MARK: - UIImage Utilities
extension UIImage {
    
    func save(_ image: Image) {
        image.save(self)
    }
    
    class func load(_ image: Image) -> UIImage? {
        return image.load()
    }
}
