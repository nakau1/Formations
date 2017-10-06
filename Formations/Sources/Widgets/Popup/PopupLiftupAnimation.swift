// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class PopupLiftupAnimation: PopupAnimatable {
    
    let height: CGFloat
    
    init(height: CGFloat?) {
        self.height = height ?? 250
    }
    
    func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        return CGRect(
            x: 0,
            y: containerSize.height - self.height,
            width: containerSize.width,
            height: self.height
        )
    }
    
    class Present: PopupAnimatedTransitioning {
        
        let height: CGFloat
        
        init(_ options: PopupOptions, height: CGFloat) {
            self.height = height
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            
            let fromView = transitionContext.view(forKey: .from)
            let fromController = transitionContext.viewController(forKey: .from)
            print(String(describing: type(of: fromController!)))
            fromView?.frame = transitionContext.finalFrame(for: fromController!)
            fromView?.transform = CGAffineTransform(translationX: 0, y: height)
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: 0, y: height)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView?.transform = CGAffineTransform.identity
                toView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    class Dismiss: PopupAnimatedTransitioning {
        
        let height: CGFloat
        
        init(_ options: PopupOptions, height: CGFloat) {
            self.height = height
            super.init(options)
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to)
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: { [unowned self] in
                fromView.transform = CGAffineTransform(translationX: 0, y: self.height)
                toView.transform = CGAffineTransform(translationX: 0, y: self.height)
                }, completion: { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(finished)
            })
        }
    }
    
    var popupOptions: PopupOptions!
    
    var present: PopupAnimatedTransitioning { return Present(popupOptions, height: self.height) }
    var dismiss: PopupAnimatedTransitioning { return Dismiss(popupOptions, height: self.height) }
}

