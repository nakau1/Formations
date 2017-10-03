// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TestViewController: UIViewController {
    
    @IBOutlet private weak var board: PositionBoardView!
    
    // MARK: ファクトリメソッド
    class func create() -> UIViewController {
        return R.storyboard.testViewController.instantiate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board.pins = (0..<11).map { i -> PositionBoardPin in
            let view = UIView(frame: CGRect(width: 44, height: 44))
            view.layer.cornerRadius = 22
            view.backgroundColor = .black
            let p = (i.f * 40.f) / (11.f * 40.f)
            return PositionBoardPin(view: view, percentage: CGPercentage(p, p))
        }
        board.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction private func didTapTest() {
		board.reloadData()
    }
}
