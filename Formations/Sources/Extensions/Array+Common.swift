// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import Foundation

extension Array {
	
	func properIndex(_ index: Int?) -> Int? {
		guard let i = index, !isEmpty else {
			return nil
		}
		if i < startIndex {
			return startIndex
		} else if endIndex < i {
			return endIndex
		} else {
			return i
		}
	}
}
