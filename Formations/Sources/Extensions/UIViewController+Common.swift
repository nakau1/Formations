// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

// MARK: - Transfer -

extension UIViewController {
    
    /// ビューコントローラをプッシュする
    /// - Parameter viewController: ビューコントローラ
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// ビューコントローラをポップする
    func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    
    /// ビューコントローラをモーダル表示する
    /// - Parameters:
    ///   - viewController: ビューコントローラ
    ///   - completion: 完了時処理
    func present(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        present(viewController, animated: true, completion: completion)
    }
    
    /// モーダル表示している自身を閉じる
    /// - Parameters:
    ///   - completion: 完了時処理
    func dismiss(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}

// MARK: - Navigation -

class NavigationController: UINavigationController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController {
    
    var withinNavigation: NavigationController {
        var vc = self
        if let navi = vc as? UINavigationController {
            vc = navi.viewControllers.first!
        }
        return NavigationController(rootViewController: vc)
    }
    
    func prepareNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = #colorLiteral(red: 0.03529411765, green: 0.08235294118, blue: 0.05098039216, alpha: 1)
        navigationBar.tintColor = #colorLiteral(red: 0.2980392157, green: 0.6588235294, blue: 0.4156862745, alpha: 1)
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2980392157, green: 0.6588235294, blue: 0.4156862745, alpha: 1),
            //NSAttributedStringKey.font: UIFont.bold5
        ]
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationBar.layer.shadowOpacity = 0.5
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
}

