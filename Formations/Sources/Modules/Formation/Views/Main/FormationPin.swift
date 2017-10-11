// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class FormationPin: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var faceImageView: UIImageView!
    
    class func create() -> FormationPin {
        return R.nib.formationPin.firstView(owner: nil)!
    }
    
    func set(position: Position?, player: Player?) {
        faceImageView.isUserInteractionEnabled = true
        faceImageView.layer.cornerRadius = faceImageView.bounds.width / 2
        if let position = position {
            faceImageView.layer.borderColor = position.backgroundColor.cgColor
        }
        faceImageView.layer.borderWidth = 2
        faceImageView.clipsToBounds = true
        
        if let image = player?.loadThumbImage(force: true).thumbImage {
            faceImageView.image = image
        } else {
            faceImageView.image = UIImage.filled(color: UIColor(white: 0.5, alpha: 0.5), size: CGSize(square: 80))
        }
        
        if let name = player?.name, let uniformNumber = player?.uniformNumber {
            nameLabel.text = "\(uniformNumber) \(name)"
        } else {
            nameLabel.text = ""
        }
    }
}
