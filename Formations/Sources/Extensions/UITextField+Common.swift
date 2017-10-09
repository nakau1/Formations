// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

extension UITextField {
    
    var textValue: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}
