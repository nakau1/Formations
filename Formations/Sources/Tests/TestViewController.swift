// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TestViewController: UIViewController {
	
	// MARK: ファクトリメソッド
    class func create() -> UIViewController {
        return R.storyboard.testViewController.instantiate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	@IBAction private func didTapTest(button: CircleColorButton) {
        ColorPicker.show(from: self, defaultColor: #colorLiteral(red: 0.9093225598, green: 0.7241044641, blue: 0.9386705756, alpha: 1)) { color in
            button.buttonColor = color
        }
    }
}
