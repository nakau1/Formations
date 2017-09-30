// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupZoomAnimation: PopupAnimatable {
    
    let scale: CGFloat
    
    init(scale: CGFloat?) {
        self.scale = scale ?? 0.25
    }
    
    class Present: PopupAnimatedTransitioning {
        
        let scale: CGFloat
        
        init(_ options: PopupOptions, scale: CGFloat) {
            self.scale = scale
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.alpha = 0
            toView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    class Dismiss: PopupAnimatedTransitioning {
        
        let scale: CGFloat
        
        init(_ options: PopupOptions, scale: CGFloat) {
            self.scale = scale
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                fromView.alpha = 0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions, scale: scale) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions, scale: scale) }
}
