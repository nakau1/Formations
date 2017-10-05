// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

extension UIImage {
    
    /// 空の画像を返す
    /// - Parameter size: サイズ
    /// - Returns: 空の画像
    class func emptyImage(size: CGSize) -> UIImage {
        return imageFromContext(size) { _ in }
    }
    
    var retina: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: .up)
    }
    
    /// 指定のサイズに拡大縮小した画像を生成して返す
    /// - parameter size: サイズ
    /// - returns: 拡大縮小した画像
    func scaled(to size: CGSize) -> UIImage {
        return imageFromContext(size) { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// サイズは固定して画像のサイズだけを変更した画像を生成して返す
    /// - parameter size: サイズ
    /// - parameter position:
    /// - returns: サイズ変更した画像
    func resized(to size: CGSize, position: CGPoint? = nil) -> UIImage {
        let pos = position ?? self.size.center(of: size)
        return imageFromContext(size) { _ in
            let rect = CGRect(origin: pos, size: self.size)
            draw(in: rect)
        }
    }
    
    /// 指定の領域で切り取った画像を生成して返す
    /// - parameter rect: 切り取る領域
    /// - returns: 切り取った画像
    func cropped(to rect: CGRect) -> UIImage {
        guard let ref = cgImage?.cropping(to: rect) else {
            return UIImage.emptyImage(size: rect.size)
        }
        return UIImage(cgImage: ref, scale: scale, orientation: imageOrientation)
    }
    
    /// 指定した画像を重ね合わせた画像を生成して返す
    /// - parameter image: 重ねる画像
    /// - parameter position: サイズ
    /// - returns: 合成した画像
    func synthesized(image: UIImage, position: CGPoint? = nil) -> UIImage {
        return imageFromContext(self.size) { _ in
            self.draw(in: CGRect(size: self.size))
            
            let pos = position ?? image.size.center(of: self.size)
            image.draw(in: CGRect(origin: pos, size: image.size))
        }
    }
    
    /// 指定した色で埋めた画像を生成して返す
    /// - parameter color: 色
    /// - parameter size: サイズ
    /// - returns: 指定した色で埋めた画像
    class func filled(color: UIColor?, size: CGSize) -> UIImage {
        return imageFromContext(size) { context in
            let filledColor = color ?? UIColor.clear
            context.saveGState()
            context.setFillColor(filledColor.cgColor)
            context.fill(CGRect(origin: CGPoint.zero, size: size))
            context.restoreGState()
        }
    }
    
    /// 透明のような見た目の画像を指定したサイズで生成して返す
    /// - Parameter size: サイズ
    /// - Returns: 透明のような見た目の画像
    class func transparentImage(size: CGSize, squareWidth: CGFloat = 10.0) -> UIImage {
        return imageFromContext(size) { context in
            let square = squareWidth
            var oddRow = false
            var oddCol = false
            
            var loc = CGPoint(x: -(size.width % squareWidth / 2), y: -(size.height % squareWidth / 2))
            
            while loc.y < size.height {
                oddRow = !oddRow
                oddCol = oddRow
                while loc.x < size.width {
                    let color = oddCol ? UIColor.white.withAlphaComponent(0.6) : UIColor.white.withAlphaComponent(0.3)
                    let frame = CGRect(x: loc.x, y: loc.y, width: square, height: square)
                    context.saveGState()
                    context.setFillColor(color.cgColor)
                    context.fill(frame)
                    context.restoreGState()
                    loc.x += square
                    oddCol = !oddCol
                }
                loc.x = -(size.width % squareWidth / 2)
                loc.y += square
            }
        }
    }
    
    /// 指定したサイズに収まるように拡大縮小(またはリサイズ)と切り取りをを行った画像を生成して返す
    /// - parameter size: 変更後のサイズ
    /// - parameter expand: 拡大縮小させる(元画像を引き延ばす)かどうか
    /// - returns: 画像
    func adjusted(to size: CGSize, shouldExpand expand: Bool = true) -> UIImage {
        
        // 再帰的に適切なサイズを探す内部関数
        func findProperSize(_ src: CGSize, dst: CGSize, reverse: Bool = false) -> CGSize {
            
            let scale: CGFloat, w: CGFloat, h: CGFloat
            
            if (!reverse && src.width > src.height) || (reverse && src.height > src.width) {
                scale = dst.width / src.width
                w = dst.width
                h = CGFloat(lroundf(Float(src.height * scale)))
            } else {
                scale = dst.height / src.height
                w = CGFloat(lroundf(Float(src.width * scale)))
                h = dst.height
            }
            
            let ret = CGSize(width: w, height: h)
            if w < dst.width || h < dst.height {
                return findProperSize(ret, dst: dst, reverse: !reverse)
            } else {
                return ret
            }
        }
        let scaledSize = findProperSize(self.size, dst: size)
        
        // 拡大縮小されたサイズから切り取る領域を計算
        var cropRect = CGRect(size: size)
        if scaledSize.width > size.width {
            cropRect.origin.x = (scaledSize.width - size.width) / 2
        }
        if scaledSize.height > size.height {
            cropRect.origin.y = (scaledSize.height - size.height) / 2
        }
        
        // 拡大縮小実行
        var ret: UIImage
        if expand {
            ret = self.scaled(to: scaledSize)
        } else {
            ret = self.resized(to: scaledSize)
        }
        // 切り取り実行
        ret = ret.cropped(to: cropRect)
        
        return ret
    }
}

extension Array where Element == UIImage {
    
    /// すべての画像を順に合成した画像を作成する
    /// - Parameter center: true 画像は中央に配置される。false 画像は左上に配置される
    /// - Returns: 合成した画像
    func synthesize(center: Bool = true) -> UIImage? {
        guard let size = first?.size else { return nil }
        return UIImage.imageFromContext(size) { _ in
            forEach {
                if center {
                    $0.draw(in: CGRect(size: $0.size, centerOf: size))
                } else {
                    $0.draw(in: CGRect(size: $0.size))
                }
            }
        }
    }
}

private extension UIImage {
    
    class func imageFromContext(_ size: CGSize, _ block: (CGContext)->Void) -> UIImage {
        UIGraphicsBeginImageContext(size)
        block(UIGraphicsGetCurrentContext()!)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret!
    }
    
    func imageFromContext(_ size: CGSize, _ block: (CGContext)->Void) -> UIImage {
        return UIImage.imageFromContext(size, block)
    }
}
