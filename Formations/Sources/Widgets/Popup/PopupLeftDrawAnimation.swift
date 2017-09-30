// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupLeftDrawAnimation: PopupAnimatable {
    
    let width: CGFloat
    
    init(width: CGFloat?) {
        self.width = width ?? 200
    }
    
    func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: self.width,
            height: containerSize.height
        )
    }
    
    class Present: PopupAnimatedTransitioning {
        
        let width: CGFloat
        
        init(_ options: PopupOptions, width: CGFloat) {
            self.width = width
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
            toView.transform = CGAffineTransform(translationX: -width, y: 0)
            
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
        
        let width: CGFloat
        
        init(_ options: PopupOptions, width: CGFloat) {
            self.width = width
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: { [unowned self] in
                fromView.transform = CGAffineTransform(translationX: -self.width, y: 0)
                fromView.alpha = 0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions, width: self.width) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions, width: self.width) }
}

