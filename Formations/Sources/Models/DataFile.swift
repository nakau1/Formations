// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

enum DataFile: FileType {
    
    case formation(teamId: String)
    
    var directory: String {
        switch self {
        case .formation:
            return "formations"
        }
    }
    
    var name: String {
        switch self {
        case let .formation(teamId): return teamId
        }
    }
    
    var extensionName: String {
        return "plist"
    }
}

extension DataFile {
    
    func save(_ data: Any?) {
        makeDirectoryIfNeeded()
//        if let image = image {
//            let data = UIImagePNGRepresentation(process(image))
//            try? data?.write(to: URL(fileURLWithPath: path), options: [.atomic])
//        } else {
//            delete()
//        }
    }
    
    func load() -> UIImage? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return UIImage(data: data)
    }
}
