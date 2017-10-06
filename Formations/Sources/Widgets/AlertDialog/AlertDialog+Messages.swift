// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

extension AlertDialog {
    
    class func showConfirmNewSave(from viewController: UIViewController, targetName: String, save: @escaping TappedHandler, dispose: @escaping TappedHandler) {
        let message = "この\(targetName)を新しく保存しますか?"
        AlertDialog.show(from: viewController, message: message, mode: .saveDispose, rightTapped: save, leftTapped: dispose)
    }
}
