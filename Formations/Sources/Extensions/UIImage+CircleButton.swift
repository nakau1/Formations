// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

extension UIImage {
    
    /// "追加"用の"+"ボタン画像
    class var addImage: UIImage {
        let length = 210.f, lineWidth = 16.f
        UIGraphicsBeginImageContext(CGSize(length, length))
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(lineWidth)
        context.move(to: CGPoint(length / 2, lineWidth / 2))
        context.addLine(to: CGPoint(length / 2, length - (lineWidth / 2)))
        context.move(to: CGPoint(lineWidth / 2, length / 2))
        context.addLine(to: CGPoint(length - (lineWidth / 2), length / 2))
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.strokePath()
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret!.retina
    }
}
