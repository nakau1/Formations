// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupRiseAnimation: PopupAnimatable {
    
    let offset: CGFloat
    
    init(offset: CGFloat?) {
        self.offset = offset ?? 30
    }
    
    class Present: PopupAnimatedTransitioning {
        
        let offset: CGFloat
        
        init(_ options: PopupOptions, offset: CGFloat) {
            self.offset = offset
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
            toView.transform = CGAffineTransform(translationX: 0, y: offset)
            
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
        
        let offset: CGFloat
        
        init(_ options: PopupOptions, offset: CGFloat) {
            self.offset = offset
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: 0, y: self.offset)
                fromView.alpha = 0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions, offset: offset) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions, offset: offset) }
}
