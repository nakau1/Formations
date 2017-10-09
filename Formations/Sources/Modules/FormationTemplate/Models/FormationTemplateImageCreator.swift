// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class FormationTemplateImageCreator {
    
    let imageSize = CGSize(600, 480)
    let pinWidth = 32.f
    
    func create(template: FormationTemplate) -> UIImage {
        return UIImage.imageFromContext(imageSize) { context in
            context.saveGState()
            context.setFillColor(#colorLiteral(red: 0.1653756027, green: 0.3886132046, blue: 0.5423990885, alpha: 1).cgColor)
            context.fill(CGRect(size: imageSize))
            context.restoreGState()
            
            let maxPoint = CGPoint(imageSize.width - pinWidth, imageSize.height - pinWidth)
            template.items.forEach { item in
                let center = (maxPoint * item.percentage) + CGPoint(pinWidth / 2, pinWidth / 2)
                let size = CGSize(square: pinWidth)
                let rect = CGRect(origin: center, size: size)
                
                context.saveGState()
                context.setFillColor(item.position.backgroundColor.cgColor)
                context.fillEllipse(in: rect)
                context.restoreGState()
            }
        }
    }
}
