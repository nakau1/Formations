// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class ImagePicker {
	
	typealias SelectedHandler = (UIImage) -> Void
	
	static let sourceType: UIImagePickerControllerSourceType = .photoLibrary
	
	var selected: SelectedHandler!
	
	private static var sharedInstance: ImagePickerInstance? = nil
	
	/// イメージピッカーを表示する
	///
	/// - Parameters:
	///   - viewController: 表示元のビューコントローラ
	///   - selected: 選択時の処理
	class func show(from viewController: UIViewController, selected: @escaping SelectedHandler) {
		if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
			return
		}
		createSharedInstance(selected: selected)
		Popup.show(imagePickerController, from: viewController, options: popupOptions)
	}
	
	fileprivate class func createSharedInstance(selected: @escaping SelectedHandler) {
		sharedInstance = ImagePickerInstance()
		sharedInstance!.selected = selected
	}
	
	fileprivate class func disposeSharedInstance() {
		sharedInstance = nil
	}
	
	private static var imagePickerController: UIImagePickerController {
		let vc = UIImagePickerController()
		vc.allowsEditing = false
		vc.sourceType = sourceType
		vc.delegate = sharedInstance
		return vc
	}
	
	private static var popupOptions: PopupOptions {
		var options = PopupOptions(.rise(offset: nil))
		options.fixedSize = sizeOfImagePicker
		return options
	}
	
	private static var sizeOfImagePicker: CGSize {
		let width = UIScreen.main.bounds.width - 32 // both-side-margin = 16
		let height = width * 1.5
		return CGSize(width: width, height: height)
	}
}

private class ImagePickerInstance: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	private static var sharedInstance: ImagePickerInstance? = nil
	
	var selected: ImagePicker.SelectedHandler!
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			selected(image)
		}
		picker.dismiss(animated: true) {
			ImagePicker.disposeSharedInstance()
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true) {
			ImagePicker.disposeSharedInstance()
		}
	}
}
