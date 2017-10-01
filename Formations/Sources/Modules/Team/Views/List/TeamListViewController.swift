// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TeamListViewController: UIViewController {
    
    // MARK: ファクトリメソッド
    class func create() -> UIViewController {
        return R.storyboard.teamListViewController.instantiate(self) { vc in
            
        }
    }
    
    // MARK: ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

// MARK: - Private -
private extension TeamListViewController {
    
    /// ビューの初期処理
    func prepare() {
        prepareNavigationBar()
    }
}
