// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupNoneAnimation: PopupAnimatable {
    
    class Present: PopupAnimatedTransitioning {
        
        override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            toView.frame = transitionContext.finalFrame(for: toController)
            toView.alpha = 1
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        }
    }
    
    class Dismiss: PopupAnimatedTransitioning {
        
        override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            fromView.alpha = 0
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions) }
}
