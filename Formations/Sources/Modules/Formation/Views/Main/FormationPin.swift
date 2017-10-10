// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class FormationPin: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    class func create(position: Position) -> FormationPin {
        let ret = R.nib.formationPin.firstView(owner: nil)!
//        ret.imageView.isUserInteractionEnabled = true
//        ret.imageView.layer.cornerRadius = ret.bounds.width / 2
//        ret.imageView.layer.borderColor = position.backgroundColor.withBrightnessComponent(0.64).cgColor
//        ret.imageView.layer.borderWidth = 2
//        ret.imageView.clipsToBounds = true
//        ret.imageView.image = UIImage.filled(color: position.backgroundColor, size: ret.bounds.size)
        return ret
    }
}

