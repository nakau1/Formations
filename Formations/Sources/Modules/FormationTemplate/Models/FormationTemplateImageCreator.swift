// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class FormationTemplateImageCreator {
    
    let imageSize = CGSize(600, 480)
    let pinWidth = 32.f
    
    func create(template: FormationTemplate) -> UIImage {
        let baseImage = R.image.formationTemplateBg()!.scaled(to: imageSize)
        let pinsImage = UIImage.imageFromContext(imageSize) { context in
            //context.drawImage(R.image.formationTemplateBg(), in: CGRect(size: imageSize))
            
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
        return baseImage.synthesized(image: pinsImage)
    }
}
