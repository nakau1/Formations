// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

protocol FileType {
    var directory: String { get }
    var name: String { get }
    var extensionName: String { get }
}

extension FileType {
    
    var path: String {
        let components = [
            Self.documentDirectory,
            Self.resourceDirectory,
            directory,
            "\(name).\(extensionName)"
        ]
        return components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
    }
    
    var directoryPath: String {
        let components = [
            Self.documentDirectory,
            Self.resourceDirectory,
            directory,
            ]
        return components.reduce("") { ($0 as NSString).appendingPathComponent($1) }
    }
    
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    func delete() {
        if exists {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
    
    func makeDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: directoryPath) {
            try! FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    static func deleteAll() {
        let path = [Self.documentDirectory, Self.resourceDirectory].reduce("") {
            ($0 as NSString).appendingPathComponent($1)
        }
        if FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
    
    static var resourceDirectory: String { return "resources" }
    
    static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    }
}
