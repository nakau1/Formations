// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class FormationPin: UIView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var faceImageView: UIImageView!
    
    class func create(name: String, borderColor: UIColor?, image: UIImage?) -> FormationPin {
        let ret = R.nib.formationPin.firstView(owner: nil)!
        ret.prepareImageView()
        ret.setImage(image)
        ret.setName(name)
        ret.setBorderColor(borderColor)
        return ret
    }
    
    private func prepareImageView() {
        faceImageView.isUserInteractionEnabled = true
        faceImageView.layer.cornerRadius = faceImageView.bounds.width / 2
        faceImageView.layer.borderWidth = 2
        faceImageView.clipsToBounds = true
    }
    
    func setImage(_ image: UIImage?) {
        if let _ = image {
            faceImageView.image = image
        } else {
            faceImageView.image = UIImage.filled(color: UIColor(white: 0.5, alpha: 0.5), size: CGSize(square: 80))
        }
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setBorderColor(_ borderColor: UIColor?) {
        faceImageView.layer.borderColor = (borderColor ?? .gray).cgColor
    }
}
