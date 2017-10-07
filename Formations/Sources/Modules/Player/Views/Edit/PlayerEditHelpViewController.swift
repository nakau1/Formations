// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class PlayerEditHelpViewController: UIViewController {
	
	enum Mode: String {
		case faceImage, fullImage
	}
	
	private var delete: (() -> Void)!
	
	// MARK: ファクトリメソッド
	class func create(mode: Mode, delete: @escaping () -> Void) -> UIViewController {
		return R.storyboard.playerEditViewController().instatiate(self, id: mode.rawValue) { vc in
			vc.delete = delete
		}
	}
	
	@IBAction private func didTapDeleteButton() {
		dismiss() {
			self.delete()
		}
	}
}

