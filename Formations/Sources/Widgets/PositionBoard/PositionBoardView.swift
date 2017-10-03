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
    
    var pins = [PositionBoardPin]()
    
    private var origins = [Int : CGPoint]()
    private var points  = [Int : CGPoint]()
    
    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        origins = [:]
        points  = [:]
        
        for index in (0..<pins.count) {
            let pin = pins[index]
            guard let view = pin.view else { continue }
            
            view.frame = frame(of: pin)
            view.tag = index
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureDidHandle(gesture:))))
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureDidHandle(gesture:))))
            addSubview(view)
        }
    }
    
    @objc func panGestureDidHandle(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        
        switch gesture.state {
        case .began:
            origins[index] = view.frame.origin
            points[index]  = gesture.translation(in: self)
        case .changed:
            guard let origin = updatedOrigin(index, gesture) else { return }
            
            if isMovabilityArea(origin, in: view) {
                view.frame.origin = origin
            } else {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        case .ended, .cancelled:
            guard let origin = updatedOrigin(index, gesture) else { return }
            pins[index].percentage = percentage(of: pins[index], origin: origin)
        default:break
        }
    }
    
    @objc func tapGestureDidHandle(gesture: UITapGestureRecognizer) {
        
    }
    
    private func updatedOrigin(_ index: Int, _ gesture: UIPanGestureRecognizer) -> CGPoint? {
        guard
            let origin = origins[index],
            let point = points[index]
            else {
                return nil
        }
        let newPoint  = gesture.translation(in: self)
        return origin + newPoint - point
    }
    
    private func frame(of pin: PositionBoardPin) -> CGRect {
        var ret = maximumFrame(of: pin)
        ret.origin = ret.origin * pin.percentage
        return ret
    }
    
    private func percentage(of pin: PositionBoardPin, origin: CGPoint) -> CGPercentage {
        let maxFrame = maximumFrame(of: pin)
        let x = origin.x / maxFrame.minX
        let y = origin.y / maxFrame.minY
        return CGPercentage(x, y)
    }
    
    private func maximumFrame(of pin: PositionBoardPin) -> CGRect {
        let size = pin.view?.bounds.size ?? .zero
        let origin = CGPoint(bounds.width - size.width, bounds.height - size.height)
        return CGRect(origin: origin, size: size)
    }
    
    private func isMovabilityArea(_ origin: CGPoint, in view: UIView) -> Bool {
        let movabilityRect = CGRect(
            width:  bounds.width  - view.frame.width,
            height: bounds.height - view.frame.height
        )
        return movabilityRect.contains(origin)
    }
}
