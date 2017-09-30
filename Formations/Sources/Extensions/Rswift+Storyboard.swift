// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

extension StoryboardResourceWithInitialControllerType {
    
    func instantiate<T: UIViewController>(_ type: T.Type, setup: ((T)->Void)? = nil) -> T {
        guard let vc = self.instantiateInitialViewController() as? T else {
            fatalError("faild create view-controller from storyboard.")
        }
        setup?(vc)
        return vc
    }
    
    func instantiate<T: UIViewController>(withinNavigation type: T.Type, setup: ((T)->Void)? = nil) -> UINavigationController {
        let vc = instantiate(type)
        setup?(vc)
        return UINavigationController(rootViewController: vc)
    }
}

extension UIStoryboard {
    
    func instatiate<T: UIViewController>(_ type: T.Type, id storyboardIdentifier: String, setup: ((T)->Void)? = nil) -> T {
        guard let vc = self.instantiateViewController(withIdentifier: storyboardIdentifier) as? T else {
            fatalError("faild create view-controller from storyboard.")
        }
        setup?(vc)
        return vc
    }
}
