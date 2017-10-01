// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class TextPicker: UIViewController {
	
	typealias SelectedHandler = (String) -> Void
	
	var selected: TextPicker.SelectedHandler!
	
	/// テキストピッカーを表示する
	///
	/// - Parameters:
	///   - viewController: 表示元のビューコントローラ
	///   - selected: 選択時の処理
	class func show(from viewController: UIViewController, selected: @escaping SelectedHandler) {
		let textPicker = R.storyboard.textPicker.instantiate(self)
		textPicker.selected = selected
		
		Popup.show(textPicker, from: viewController, options: PopupOptions(.rise(offset: nil)))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.layer.cornerRadius = 10
	}
}

extension TextPicker: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 10
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "\(row)"
	}
}
