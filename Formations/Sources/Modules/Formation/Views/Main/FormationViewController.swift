// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class FormationViewController: UIViewController {
    
    private var team: Team!
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.formationViewController.instantiate(self) { vc in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
}
