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
    
    @IBAction private func didTapTest() {
		
		let items = UIFont.familyNames.map {
			TextPicker.item($0)
		}
		
		TextPicker.show(from: self, items: items) { item in
			print(item)
		}
    }
}
