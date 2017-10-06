// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

@IBDesignable class Button: UIButton {
    
    @IBInspectable var buttonColor: UIColor? = nil {
        didSet {
            render()
        }
    }
    
    override func draw(_ rect: CGRect) {
        render()
    }
    
    private func render() {
        layer.cornerRadius = 5
        clipsToBounds = true
        
        let image = UIImage.filled(color: buttonColor, size: bounds.size)
        setBackgroundImage(image, for: .normal)
    }
}
