// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

struct PositionBoardPin {
    
    var view: UIView? = nil
    var percentage = CGPercentage()
}

class PositionBoardView: UIView {
    
    /// ピンを移動し終えた時
    /// - Parameters:
    ///   - pin: ピン
    ///   - index: インデックス
    typealias MovedHandler = (_ pin: PositionBoardPin, _ index: Int) -> Void
    
    /// ピンをタップした時
    /// - Parameters:
    ///   - pin: ピン
    ///   - index: インデックス
    typealias TappedHandler = (_ pin: PositionBoardPin, _ index: Int) -> Void
    
    /// 配置するピン
    var pins = [PositionBoardPin]()
    
    /// ピンを移動させることができるかどうか
    var isMovable = true
    
    /// ピンを移動し終えた時の処理
    var moved: MovedHandler?
    
    /// ピンをタップした時の処理
    var tapped: TappedHandler?
    
    private var origins = [Int : CGPoint]()
    private var points  = [Int : CGPoint]()
    
    /// リロードを行う
    /// - Parameter pins: 配置するピン(省略可)
    func reloadData(pins: [PositionBoardPin]? = nil) {
        if let pins = pins {
            self.pins = pins
        }
        
        subviews.forEach { $0.removeFromSuperview() }
        origins = [:]
        points  = [:]
        
        for index in (0..<self.pins.count) {
            let pin = self.pins[index]
            guard let view = pin.view else { continue }
            
            view.frame = frame(of: pin)
            view.tag = index
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureDidHandle(gesture:))))
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureDidHandle(gesture:))))
            addSubview(view)
        }
    }
    
    @objc func panGestureDidHandle(gesture: UIPanGestureRecognizer) {
        if !isMovable { return }
        let index = gesture.view!.tag
        
        switch gesture.state {
        case .began:
            origins[index] = gesture.view!.frame.origin
            points[index]  = gesture.translation(in: self)
        case .changed:
            guard let origin = updatedOrigin(of: gesture, at: index) else { return }
            
            if isMovabilityArea(origin, in: gesture.view!) {
                gesture.view!.frame.origin = origin
            } else {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        case .ended, .cancelled:
            guard let origin = updatedOrigin(of: gesture, at: index) else { return }
            pins[index].percentage = percentage(of: pins[index], origin: origin)
            moved?(pins[index], index)
        default:break
        }
    }
    
    @objc func tapGestureDidHandle(gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag
        tapped?(pins[index], index)
    }
    
    /// ジェスチャレコグナイザからピンの移動先の位置を計算して返す
    private func updatedOrigin(of gesture: UIPanGestureRecognizer, at index: Int) -> CGPoint? {
        guard
            let origin = origins[index],
            let point = points[index]
            else {
                return nil
        }
        let newPoint  = gesture.translation(in: self)
        return origin + newPoint - point
    }
    
    /// 指定したピンから矩形座標を計算して返す
    private func frame(of pin: PositionBoardPin) -> CGRect {
        var ret = maximumFrame(of: pin)
        ret.origin = ret.origin * pin.percentage
        return ret
    }
    
    /// 指定した座標からXY座標のパーセンテージを計算して返す
    private func percentage(of pin: PositionBoardPin, origin: CGPoint) -> CGPercentage {
        let maxFrame = maximumFrame(of: pin)
        let x = origin.x / maxFrame.minX
        let y = origin.y / maxFrame.minY
        return CGPercentage(x, y)
    }
    
    /// 指定したピンの稼働可能な限界の矩形座標を返す
    private func maximumFrame(of pin: PositionBoardPin) -> CGRect {
        let size = pin.view?.bounds.size ?? .zero
        let origin = CGPoint(bounds.width - size.width, bounds.height - size.height)
        return CGRect(origin: origin, size: size)
    }
    
    /// 指定した座標(origin)が稼働可能な位置かどうかを返す
    private func isMovabilityArea(_ origin: CGPoint, in view: UIView) -> Bool {
        let movabilityRect = CGRect(
            width:  bounds.width  - view.frame.width,
            height: bounds.height - view.frame.height
        )
        return movabilityRect.contains(origin)
    }
}
