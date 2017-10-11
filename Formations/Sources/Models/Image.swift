// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

enum Image: FileType {
    
    case playerFace(id: String)
    case playerThumb(id: String)
    case playerFull(id: String)
    case teamEmblem(id: String)
    case teamSmallEmblem(id: String)
    case teamImage(id: String)
    case formationTemplate(id: String)
    case test(id: String)
    case testOrigin(id: String)
    
    enum Category: String {
        case players
        case teams
        case formationTemplates = "formation_templates"
        case test
    }

    var directory: String {
        switch self {
        case let .playerFace(id), let .playerThumb(id), let .playerFull(id):
            return "\(Category.players.rawValue)/\(id)"
        case let .teamEmblem(id), let .teamSmallEmblem(id), let .teamImage(id):
            return "\(Category.teams.rawValue)/\(id)"
        case .formationTemplate:
            return "\(Category.formationTemplates.rawValue)"
        case .test, .testOrigin:
            return Category.test.rawValue
        }
    }
    
    var name: String {
        switch self {
        case .playerFace:                return "face"
        case .playerThumb:               return "thumb"
        case .playerFull:                return "full"
        case .teamEmblem:                return "emblem"
        case .teamSmallEmblem:           return "small_emblem"
        case .teamImage:                 return "image"
        case let .formationTemplate(id): return id
        case let .test(id):              return id
        case let .testOrigin(id):        return id + "_org"
        }
    }
    
    var extensionName: String {
        return "png"
    }
    
    func process(_ image: UIImage) -> UIImage {
        switch self {
        case .playerFace:
            return image.adjusted(to: CGSize(400, 400), shouldExpand: true)
        case .playerThumb:
            return image.adjusted(to: CGSize(240, 240), shouldExpand: true)
        case .playerFull:
            return image.adjusted(to: CGSize(1200, 1600), shouldExpand: true)
        case .teamEmblem:
            return image.adjusted(to: CGSize(400, 400), shouldExpand: true)
        case .teamSmallEmblem:
            return image.adjusted(to: CGSize(273, 273), shouldExpand: true)
        case .teamImage:
            return image.adjusted(to: CGSize(828, 1472), shouldExpand: true)
        case .formationTemplate:
            return image
        case .test:
            return image
        case .testOrigin:
            return image
        }
    }
}

extension Image {
    
    func save(_ image: UIImage?) {
        makeDirectoryIfNeeded()
        if let image = image {
            let data = UIImagePNGRepresentation(process(image))
            try? data?.write(to: URL(fileURLWithPath: path), options: [.atomic])
        } else {
            delete()
        }
    }
    
    func load() -> UIImage? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return UIImage(data: data)
    }
    
    static func delete(category: Category, id: String) {
        let components = [
            documentDirectory,
            resourceDirectory,
            category.rawValue,
            id,
            ]
        let path = components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
        if FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.removeItem(atPath: path)
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
