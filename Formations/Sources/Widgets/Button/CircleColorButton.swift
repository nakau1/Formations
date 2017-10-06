// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

@IBDesignable class CircleColorButton: UIButton {
    
    @IBInspectable var buttonColor: UIColor? = nil {
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
        renderColor()
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
    
    private func renderColor() {
        if let color = buttonColor {
            setBackgroundImage(image(color: color, size: bounds.size), for: .normal)
        } else {
            setBackgroundImage(transparentImage(size: bounds.size), for: .normal)
        }
    }
    
    private func image(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return ret
    }
    
    private let transparentImageSquareWidth: CGFloat = 10.0
    
    private func transparentImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        
        let square = transparentImageSquareWidth
        var oddRow = false
        var oddCol = false
        
        var loc = CGPoint(x: defaultOffset(size.width), y: defaultOffset(size.height))
        
        while loc.y < size.height {
            oddRow = !oddRow
            oddCol = oddRow
            while loc.x < size.width {
                let color = transparentSquareColors(oddCol)
                let frame = CGRect(x: loc.x, y: loc.y, width: square, height: square)
                context.saveGState()
                context.setFillColor(color.cgColor)
                context.fill(frame)
                context.restoreGState()
                loc.x += square
                oddCol = !oddCol
            }
            loc.x = defaultOffset(size.width)
            loc.y += square
        }
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return ret
    }
    
    private func defaultOffset(_ location: CGFloat) -> CGFloat {
        return -(CGFloat(Int(location) % Int(transparentImageSquareWidth) / 2))
    }
    
    private func transparentSquareColors(_ odd: Bool) -> UIColor {
        let i = odd ? 0 : 1
        return [UIColor.white.withAlphaComponent(0.6), UIColor.white.withAlphaComponent(0.3)][i]
    }
}

