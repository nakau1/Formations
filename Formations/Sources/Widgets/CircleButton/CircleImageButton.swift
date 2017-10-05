// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

@IBDesignable class CircleImageButton: UIButton {
    
    @IBInspectable var buttonImage: UIImage? = nil {
        didSet {
            render()
        }
    }
    
    @IBInspectable var borderColor: UIColor? = .white {
        didSet {
            render()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            render()
        }
    }
    
    override func draw(_ rect: CGRect) {
        render()
    }
    
    private func render() {
        renderRadius()
        renderBorder()
        renderImage()
    }
    
    private func renderRadius() {
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
    
    private func renderBorder() {
        if let color = borderColor {
            layer.borderWidth = borderWidth
            layer.borderColor = color.cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = nil
        }
    }
    
    private func renderImage() {
        setImage(buttonImage, for: .normal)
    }
}
