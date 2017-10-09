// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

// MARK: - String拡張: subscript -
extension String {
    
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript(start: Int, end: Int) -> String {
        let si = start < startIndex.encodedOffset ? startIndex.encodedOffset : start
        let ei = end   > endIndex.encodedOffset   ? endIndex.encodedOffset   : end
        if si > ei { return "" }
        
        let s = index(startIndex, offsetBy: si)
        let e = index(startIndex, offsetBy: ei)
        
        return String(self[s..<e])
    }
}

// MARK: - String拡張: 構成チェック -
extension String {
    
    /// 半角数字の構成
    static let structureOfNumber = "0123456789"
    
    /// 半角小文字アルファベットの構成
    static let structureOfLowercaseAlphabet = "abcdefghijklmnopqrstuvwxyz"
    
    /// 半角大文字アルファベットの構成
    static let structureOfUppercaseAlphabet = structureOfLowercaseAlphabet.uppercased()
    
    /// 半角アルファベットの構成
    static let structureOfAlphabet = structureOfLowercaseAlphabet + structureOfUppercaseAlphabet
    
    /// 半角英数字の構成
    static let structureOfAlphabetNumber = structureOfAlphabet + structureOfNumber
    
    /// 半角数字のみで構成されているかどうか
    public var isOnlyNumber: Bool {
        return isOnly(structuredBy: String.structureOfNumber)
    }
    
    /// 半角アルファベットのみで構成されているかどうか
    public var isOnlyAlphabet: Bool {
        return isOnly(structuredBy: String.structureOfAlphabet)
    }
    
    /// 半角英数字のみで構成されているかどうか
    public var isOnlyAlphabetNumber: Bool {
        return isOnly(structuredBy: String.structureOfAlphabetNumber)
    }
    
    /// 半角英数字とハイフン、半角スペースのみで構成されているかどうか
    public var isOnlyAlphabetNumberHyphenWhitespace: Bool {
        return isOnly(structuredBy: String.structureOfAlphabetNumber + " -")
    }
    
    /// 指定した文字のみで構成されているかどうかを返す
    /// - parameter chars: 指定の文字
    /// - returns: 渡した文字のみで構成されているかどうか
    public func isOnly(structuredBy chars: String) -> Bool {
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: chars)
        return trimmingCharacters(in: characterSet as CharacterSet).count <= 0
    }
}
