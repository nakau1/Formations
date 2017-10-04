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
            let view = UILabel(frame: CGRect(width: 44, height: 44))
            view.layer.cornerRadius = 22
            view.clipsToBounds = true
            view.isUserInteractionEnabled = true
            view.backgroundColor = .black
            view.textColor = .white
            view.textAlignment = .center
            view.text = "\(i)"
            let p = (i.f * 40.f) / (11.f * 40.f)
            return PositionBoardPin(view: view, percentage: CGPercentage(p, p))
        }.sorted { a, b in
            return a.percentage < b.percentage
        }
        
        board.moved = { pin, i in
            print(pin.percentage.x, pin.percentage.y, i)
        }
        
        board.tapped = { pin, i in
            print(pin)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        board.reloadData()
    }
    
    @IBAction private func didTapTest() {
		board.isMovable = !board.isMovable
    }
}
