// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class PositionNumberPicker: UIViewController {
    
	typealias Item = (text: String, object: Any?)
	typealias SelectedHandler = ([Position : Int]) -> Void
    
    private let max = 10
	
	private var selected: PositionNumberPicker.SelectedHandler!
	
    private var defaultValues: [Position : Int] = [
        .defender   : 4,
        .midfielder : 4,
        .forward    : 2,
    ]
    
    /// ポジション人数ピッカーを表示する
    ///
    /// - Parameters:
    ///   - viewController: 表示元のビューコントローラ
    ///   - df: DF人数
    ///   - mf: MF人数
    ///   - fw: FW人数
    ///   - selected: 選択時の処理
    class func show(from viewController: UIViewController, defaultValues: [Position : Int], selected: @escaping SelectedHandler) {
		let textPicker = R.storyboard.positionNumberPicker.instantiate(self)
		textPicker.defaultValues = defaultValues
        textPicker.selected = selected
		Popup.show(textPicker, from: viewController, options: PopupOptions(.rise(offset: nil)))
	}
	
	@IBOutlet private weak var pickerView: UIPickerView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        set(df: defaultValues[.defender]!, mf: defaultValues[.midfielder]!, fw: defaultValues[.forward]!)
	}
	
	@IBAction private func didTapCommitButton() {
        let values = getAll()
        selected([
            .defender   : values.df,
            .midfielder : values.mf,
            .forward    : values.fw,
        ])
		dismiss(animated: true) {}
	}
	
	@IBAction private func didTapCancelButton() {
		dismiss(animated: true) {}
	}
}

extension PositionNumberPicker {
    
    private func adjust(changedBy position: Position) {
        let total = getTotal()
        if getTotal() == max {
            return // 合計が10人なら調整の必要なし
        } else if total > max {
            adjustSubtractedDiff(total: total, position: position)
        } else if total < max {
            adjustAddedDiff(total: total, position: position)
        }
    }
    
    private func adjustAddedDiff(total: Int, position: Position) {
        let diff = max - total
        let next = nextPosition(of: position)!
        let value = get(for: next)
        
        var newValue = value + diff
        if newValue > max { newValue = max }
        set(newValue, for: next, animated: true)
        
        let total = getTotal()
        if total < max {
            adjustAddedDiff(total: total, position: next)
        }
    }
    
    private func adjustSubtractedDiff(total: Int, position: Position) {
        let diff = total - max
        let next = nextPosition(of: position)!
        let value = get(for: next)
        
        var newValue = value - diff
        if newValue < 0 { newValue = 0 }
        set(newValue, for: next, animated: true)
        
        let total = getTotal()
        if total > max {
            adjustSubtractedDiff(total: total, position: next)
        }
    }
    
    private func nextPosition(of position: Position) -> Position! {
        switch position {
        case .defender:   return .midfielder
        case .midfielder: return .forward
        case .forward:    return .defender
        default: return nil // dead-code
        }
    }
}

extension PositionNumberPicker {
    
    private func set(_ value: Int, for position: Position, animated: Bool = false) {
        pickerView.selectRow(value, inComponent: position.positionIndex, animated: animated)
    }
    
    private func set(df: Int, mf: Int, fw: Int, animated: Bool = false) {
        set(df, for: .defender,   animated: animated)
        set(mf, for: .midfielder, animated: animated)
        set(fw, for: .forward,    animated: animated)
    }
    
    private func get(for position: Position) -> Int {
        return pickerView.selectedRow(inComponent: position.positionIndex)
    }
    
    private func getAll() -> (df: Int, mf: Int, fw: Int) {
        return (df: get(for: .defender), mf: get(for: .midfielder), fw: get(for: .forward))
    }
    
    private func getTotal() -> Int {
        let all = getAll()
        return all.df + all.mf + all.fw
    }
}

extension PositionNumberPicker: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Position.formationComponents.count
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max + 1
	}
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(
            string: "\(row)",
            attributes: [.foregroundColor : Position.formationComponents[component].backgroundColor]
        )
    }
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
	}
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        adjust(changedBy: Position(at: component)!)
    }
}
