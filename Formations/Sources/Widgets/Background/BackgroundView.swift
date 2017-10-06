// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class BackgroundView: UIImageView {
    
    private static let NotificationImageKey = "image"
    
    @IBInspectable var isObserveChangeImage: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if image == nil {
            image = R.image.defaultBackground()
        }
        contentMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveDidChangeImage(notification:)),
            name: .BackgroundViewDidChangeImage,
            object: nil
        )
    }
    
    @objc func didReceiveDidChangeImage(notification: Notification) {
        if let image = notification.userInfo?[BackgroundView.NotificationImageKey] as? UIImage, isObserveChangeImage {
            let filter = UIImage.filled(
                color: UIColor(white: 0, alpha: 0.8),
                size: image.size
            )
            self.image = image.synthesized(image: filter)
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
