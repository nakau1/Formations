// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

////////////////////////////////////////////////////////////////////////////////
// MARK: - PopupOptions -
////////////////////////////////////////////////////////////////////////////////

enum PopupAnimation {
    case none
    case fade
    case zoom(scale: CGFloat?)
    case rise(offset: CGFloat?)
    case leftDraw(width: CGFloat?)
    case rightDraw(width: CGFloat?)
    case bottomDraw(height: CGFloat?)
    
    fileprivate func animatableInstance(_ options: PopupOptions) -> PopupAnimatable {
        var ret: PopupAnimatable
        switch self {
        case .none: ret = PopupNoneAnimation()
        case .fade: ret = PopupFadeAnimation()
        case let .zoom(scale): ret = PopupZoomAnimation(scale: scale)
        case let .rise(offset): ret = PopupRiseAnimation(offset: offset)
        case let .leftDraw(width): ret = PopupLeftDrawAnimation(width: width)
        case let .rightDraw(width): ret = PopupRightDrawAnimation(width: width)
        case let .bottomDraw(height): ret = PopupBottomDrawAnimation(height: height)
        }
        ret.popupOptions = options
        return ret
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - PopupOptions -
////////////////////////////////////////////////////////////////////////////////

struct PopupOptions {
    
    var animation: PopupAnimation!
    
    var animationDuration: TimeInterval = 0.25
    
    var overlayColor = UIColor.black.withAlphaComponent(0.5)
    
    var overlayIsBlur = false
    
    var overlayBlurEffectStyle = UIBlurEffectStyle.regular
    
    var overlayBlurAlpha: CGFloat = 1.0
    
    var overlayTapDismissalEnabled = true
    
    var fixedSize: CGSize?
    
    init(_ animation: PopupAnimation = .fade) {
        self.animation = animation
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - Popup -
////////////////////////////////////////////////////////////////////////////////

class Popup: NSObject {
    
    fileprivate static var popupInstances = [Popup]()
    
    private var popupOptions: PopupOptions!
    
    /// ポップアップ表示を行う
    ///
    /// - Parameters:
    ///   - presentedViewController: 表示するビューコントローラ
    ///   - presentingViewController: 表示元のビューコントローラ
    ///   - options: オプション
    ///   - completion: 表示完了時の処理
    class func show(_ presentedViewController: UIViewController, from presentingViewController: UIViewController, options: PopupOptions? = nil, completion: (() -> Void)? = nil) {
        let popupInstance = Popup()
        popupInstance.popupOptions = options ?? PopupOptions()
        Popup.popupInstances.append(popupInstance)
        
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.transitioningDelegate = popupInstance
        
        presentingViewController.present(presentedViewController, animated: true, completion: completion)
    }
}

extension Popup: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            options: popupOptions
        )
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popupOptions.animation.animatableInstance(popupOptions).present
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popupOptions.animation.animatableInstance(popupOptions).dismiss
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - PopupPresentationController -
////////////////////////////////////////////////////////////////////////////////

private class PopupPresentationController: UIPresentationController {
    
    var popupOptions: PopupOptions!
    var overlay: UIView!
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, options: PopupOptions) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.popupOptions = options
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView
            else {
                return .zero
        }
        
        if popupOptions.fixedSize == nil &&
            presentedViewController is UINavigationController || presentedViewController is UITabBarController {
            let width = UIScreen.main.bounds.width - 60
            let height = width * 0.8
            popupOptions.fixedSize = CGSize(width: width, height: height)
        }
        
        let presentedSize = popupOptions.fixedSize ??
            presentedView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        return popupOptions.animation.animatableInstance(popupOptions).frame(
            containerSize: containerView.bounds.size,
            presentedSize: presentedSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        
        if popupOptions.overlayIsBlur {
            let effect = UIBlurEffect(style: popupOptions.overlayBlurEffectStyle)
            overlay = UIVisualEffectView(effect: effect)
            overlay.frame = containerView.bounds
            overlay.backgroundColor = .clear
        } else {
            overlay = UIView(frame: containerView.bounds)
            overlay.backgroundColor = popupOptions.overlayColor
        }
        
        overlay.alpha = 0
        if popupOptions.overlayTapDismissalEnabled {
            overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOverlay)))
        }
        
        containerView.insertSubview(overlay, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = self.popupOptions.overlayIsBlur ? self.popupOptions.overlayBlurAlpha : 1
            }, completion: nil)
        } else {
            overlay.alpha = popupOptions.overlayIsBlur ? self.popupOptions.overlayBlurAlpha : 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            overlay.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = 0
            }, completion: nil)
        } else {
            overlay.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
            Popup.popupInstances.removeLast()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        overlay.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func didTapOverlay() {
        presentedViewController.dismiss(animated: true) {}
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - PopupAnimatable -
////////////////////////////////////////////////////////////////////////////////

protocol PopupAnimatable {
    
    var popupOptions: PopupOptions! { get set }
    
    var present: PopupAnimatedTransitioning { get }
    var dismiss: PopupAnimatedTransitioning { get }
    
    func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect
}

extension PopupAnimatable {
    
    func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        let origin = CGPoint(
            x: (containerSize.width - presentedSize.width) / 2,
            y: (containerSize.height - presentedSize.height) / 2
        )
        return CGRect(origin: origin, size: presentedSize)
    }
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - PopupAnimatedTransitioning -
////////////////////////////////////////////////////////////////////////////////

class PopupAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popupOptions: PopupOptions
    
    init(_ options: PopupOptions) {
        self.popupOptions = options
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return popupOptions.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
}
