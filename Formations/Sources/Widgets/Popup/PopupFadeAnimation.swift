// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupFadeAnimation: PopupAnimatable {
    
    class Present: PopupAnimatedTransitioning {
        
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
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    class Dismiss: PopupAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions) }
}
