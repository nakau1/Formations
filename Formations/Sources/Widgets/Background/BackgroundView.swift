// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

/*
 BackgroundView の constraint の貼り方
 
 1. vertical, horizontal ともに center にする
 2. 各面の align を superview(safe-areaではなく) に 0 で設定する
 3. leading, trailing の priority を 750 にする
 4. aspect を　414:736 にする
 */

class BackgroundView: UIImageView {
    
    private static let NotificationImageKey = "image"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if image == nil {
            image = R.image.defaultBackground()
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveDidChangeImage(notification:)),
            name: .BackgroundViewDidChangeImage,
            object: nil
        )
    }
    
    @objc func didReceiveDidChangeImage(notification: Notification) {
        if let image = notification.userInfo?[BackgroundView.NotificationImageKey] as? UIImage {
            self.image = image
        }
    }
    
    class func notifyChangeImage(_ image: UIImage?) {
        let postingImage = image ?? R.image.defaultBackground()!
        NotificationCenter.default.post(
            name: .BackgroundViewDidChangeImage,
            object: nil,
            userInfo: [BackgroundView.NotificationImageKey : postingImage]
        )
    }
}

extension Notification.Name {
    static let BackgroundViewDidChangeImage = Notification.Name("BackgroundViewDidChangeImage")
}
