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
    
    class func showOptionColorMenu(from viewController: UIViewController, delete: @escaping TappedHandler, change: @escaping TappedHandler) {
        let message = "この色はオプションです\n変更することも削除することもできます"
        AlertDialog.show(from: viewController, message: message, mode: .deleteChange, leftTapped: delete, rightDismissed: change)
    }
}
