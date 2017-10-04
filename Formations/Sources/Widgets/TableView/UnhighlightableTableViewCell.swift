// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class UnhighlightableTableViewCell: UITableViewCell {
    
    private var backgroundColoredViews = [UIView : UIColor]()
    private var shadowedViews = [UIView : (color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat)]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBackgroundColoredSubviews(of: contentView)
        addShadowedSubviews(of: contentView)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            backgroundColoredViews.forEach { view, color in
                view.backgroundColor = color
            }
            shadowedViews.forEach { view, info in
                view.layer.shadowColor   = info.color
                view.layer.shadowOffset  = info.offset
                view.layer.shadowOpacity = info.opacity
                view.layer.shadowRadius  = info.radius
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundColoredViews.forEach { view, color in
                view.backgroundColor = color
            }
            shadowedViews.forEach { view, info in
                view.layer.shadowColor   = info.color
                view.layer.shadowOffset  = info.offset
                view.layer.shadowOpacity = info.opacity
                view.layer.shadowRadius  = info.radius
            }
        }
    }
    
    private func addBackgroundColoredSubviews(of view: UIView) {
        view.subviews.forEach { subview in
            if let color = subview.backgroundColor {
                backgroundColoredViews[subview] = color
                addBackgroundColoredSubviews(of: subview)
                subview.addObserver(self, forKeyPath: #keyPath(UIView.backgroundColor), options: [.new], context: nil)
            }
        }
    }
    
    private func addShadowedSubviews(of view: UIView) {
        view.subviews.forEach { subview in
            if let color = subview.layer.shadowColor {
                shadowedViews[subview] = (
                    color:   color,
                    offset:  subview.layer.shadowOffset,
                    opacity: subview.layer.shadowOpacity,
                    radius:  subview.layer.shadowRadius
                )
                addShadowedSubviews(of: subview)
                subview.layer.addObserver(self, forKeyPath: #keyPath(CALayer.shadowColor), options: [.new], context: nil)
            }
        }
    }
    
    deinit {
        backgroundColoredViews.forEach { view, _ in
            view.removeObserver(self, forKeyPath: #keyPath(UIView.backgroundColor))
        }
        backgroundColoredViews.removeAll()
        
        shadowedViews.forEach { view, _ in
            view.layer.removeObserver(self, forKeyPath: #keyPath(CALayer.shadowColor))
        }
        shadowedViews.removeAll()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let view = object as? UIView, let key = keyPath, key == "backgroundColor", let color = change?[.newKey] as? UIColor {
            var alpha: CGFloat = 1.0
            color.getWhite(nil, alpha: &alpha)
            if alpha > 0.0 {
                backgroundColoredViews[view] = color
            }
        }
    }
}
