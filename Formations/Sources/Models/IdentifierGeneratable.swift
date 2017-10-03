// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

protocol IdentifierGeneratable {}

extension IdentifierGeneratable {
    
    func generateIdentifier() -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let count = chars.characters.count
        
        let ret = (0..<54).reduce("") { res, _ in
            let distance = String.IndexDistance(arc4random_uniform(UInt32(count)))
            let s = chars.index(chars.startIndex, offsetBy: distance)
            let e = chars.index(chars.startIndex, offsetBy: distance + 1)
            return res + chars[s..<e]
        }
        return ret + "\(UInt64(Date().timeIntervalSince1970))"
    }
}
