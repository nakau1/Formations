// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

enum Json: FileType {
    
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
        return "json"
    }
}

extension Json {
    
    func save(_ jsonString: String?) {
        makeDirectoryIfNeeded()
        if let string = jsonString {
            try? string.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
        } else {
            delete()
        }
    }
    
    func load() -> String? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
