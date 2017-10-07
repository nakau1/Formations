// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class TextPicker: UIViewController {
	
	typealias Item = (text: String, object: Any?)
	typealias SelectedHandler = (Item) -> Void
	
	private var selected: TextPicker.SelectedHandler!
	private var items = [Item]()
	
	private var defaultIndex: Int? {
		didSet {
			defaultIndex = items.properIndex(defaultIndex)
		}
	}
	
	/// テキストピッカー用のアイテムを作成する
	///
	/// - Parameters:
	///   - text: 表示する文字列
	///   - object: オブジェクト
	/// - Returns: 作成されたアイテム
	class func item(_ text: String, _ object: Any? = nil) -> Item {
		return Item(text: text, object: object)
	}
	
	/// テキストピッカーを表示する
	///
	/// - Parameters:
	///   - viewController: 表示元のビューコントローラ
	///   - selected: 選択時の処理
	class func show(from viewController: UIViewController, items: [Item], defaultIndex: Int?, selected: @escaping SelectedHandler) {
		let textPicker = R.storyboard.textPicker.instantiate(self)
		textPicker.items = items
		textPicker.selected = selected
		textPicker.defaultIndex = defaultIndex
		
		Popup.show(textPicker, from: viewController, options: PopupOptions(.rise(offset: nil)))
	}
	
	@IBOutlet private weak var pickerView: UIPickerView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let index = defaultIndex {
			pickerView.selectRow(index, inComponent: 0, animated: false)
		}
	}
	
	@IBAction private func didTapCommitButton() {
		let index = pickerView.selectedRow(inComponent: 0)
		selected(items[index])
		dismiss(animated: true) {}
	}
	
	@IBAction private func didTapCancelButton() {
		dismiss(animated: true) {}
	}
}

extension TextPicker: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return items.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return items[row].text
	}
}
