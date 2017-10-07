// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class PlayerEditViewController: UIViewController {
    
    // MARK: ファクトリメソッド
	class func create(for player: Player?, ofTeam team: Team) -> UIViewController {
		return R.storyboard.playerEditViewController.instantiate(self) { vc in
			vc.team = team
			if let player = player {
				vc.player = player
			} else {
				let newPlayer = Realm.Player.create()
				vc.player = newPlayer
				vc.isAdd = true
			}
		}
    }
	
	enum Row {
		case header(title: String)
		case name
		case familyName
		case internationalName
		case shortenedName
		case uniformNumber
		case position
		case image
		
		static var rows: [Row] {
			return [
				.header(title: "選手名"),
				.name, .familyName, .internationalName, .shortenedName,
				.header(title: "背番号"),
				.uniformNumber,
				.header(title: "ポジション"),
				.position,
				.header(title: "選手イメージ画像"),
				.image,
			]
		}
		
		var placeholderText: String {
			switch self {
			case .name:              return "フルネーム"
			case .familyName:        return "名字または通称"
			case .internationalName: return "フルネーム(英語表記)"
			case .shortenedName:     return "名字または通称(英語表記)"
			default: return ""
			}
		}
		
		var hintText: String {
			switch self {
			case .name:              return "選手のフルネームを入力します\n(30文字以内)"
			case .familyName:        return "選手の名字または通称を入力します\n(10文字以内)"
			case .internationalName: return "選手の国際上の名称を英字で入力します\n(30文字以内)"
			case .shortenedName:     return "選手の名字または通称を入力します\n(10文字以内)"
			default: return ""
			}
		}
	}
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	
	private var isAdd = false
	private var team: Team!
	private var player: Player!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareNavigationBar()
		prepareUserInterface()
		prepareBackgroundView()
		prepareTableView()
		preparePlayer()
	}
	
	private func prepareUserInterface() {
		self.title = isAdd ? "新しい選手の登録" : player.name
		if !isAdd {
			navigationItem.rightBarButtonItem = nil
		}
	}
	
	private func prepareBackgroundView() {
		let image = team.loadTeamImage().teamImage?.retina
		BackgroundView.notifyChangeImage(image)
	}
	
	private func prepareTableView() {
		tableView.estimatedRowHeight = 64
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.registerEditHeaderCell()
	}
	
	private func preparePlayer() {
		Realm.Player.clearValidateResults(player)
	}
	
	@IBAction func didTapCompleteButton() {
		AlertDialog.showConfirmNewSave(
			from: self,
			targetName: "選手",
			save: { [unowned self] in
				Realm.Player.save(self.player)
				Realm.Player.notifyChange()
				self.dismiss()
			},
			dispose: { [unowned self] in
				Image.delete(category: .players, id: self.player.id)
				self.dismiss()
			}
		)
	}
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PlayerEditViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Row.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = Row.rows[indexPath.row]
		let cell: PlayerEditTableViewCell
		
		switch row {
		case .header(let title):
			return tableView.dequeueReusableEditHeaderCell(title: title, for: indexPath)
		case .name, .internationalName, .familyName, .shortenedName:
			cell = R.reuseIdentifier.playerEditName.reuse(tableView)
		case .uniformNumber, .position:
			cell = R.reuseIdentifier.playerEditInput.reuse(tableView)
		case .image:
			cell = R.reuseIdentifier.playerEditImage.reuse(tableView)
		}
		
		cell.row = row
		cell.player = player
		cell.delegate = self
		return cell
	}
}

// MARK: - TableViewDelegate
extension PlayerEditViewController: PlayerEditTableViewDelegate {
	
	func didEditName(value: String) {
		if Realm.Player.validateName(value, of: player) {
			Realm.Player.write(player) {
				$0.name = value
				Realm.Player.notifyChange()
			}
		}
		tableView.reloadData()
	}
	
	func didEditFamilyName(value: String) {
		if Realm.Player.validateFamilyName(value, of: player) {
			Realm.Player.write(player) {
				$0.familyName = value
			}
		}
		tableView.reloadData()
	}
	
	func didEditInternationalName(value: String) {
		if Realm.Player.validateInternationalName(value, of: player) {
			Realm.Player.write(player) {
				$0.internationalName = value
			}
		}
		tableView.reloadData()
	}
	
	func didEditShortenedName(value: String) {
		if Realm.Player.validateShortenedName(value, of: player) {
			Realm.Player.write(player) {
				$0.shortenedName = value.uppercased()
			}
		}
		tableView.reloadData()
	}
	
	func didTapUniformNumber() {
//		ColorPicker.show(from: self, defaultColor: team.mainColor) { [unowned self] color in
//			Realm.Team.write(self.team) { $0.mainColor = color }
//			Realm.Team.notifyChange()
//			self.tableView.reloadData()
//		}
	}

	func didTapPosition() {
//		ColorPicker.show(from: self, defaultColor: team.subColor) { [unowned self] color in
//			Realm.Team.write(self.team) { $0.subColor = color }
//			self.tableView.reloadData()
//		}
	}
	
	func didTapFaceImage() {
		ImagePicker.show(from: self) { [unowned self] image in
			self.updateFaceImage(image)
		}
	}
	
	func didTapFullImage() {
		ImagePicker.show(from: self) { [unowned self] image in
			self.updateFullImage(image)
		}
	}
	
	func didTapFaceImageHelp() {
		let vc = PlayerEditHelpViewController.create(mode: .faceImage, delete: {
			self.updateFaceImage(nil)
		})
		Popup.show(vc, from: self, options: PopupOptions(.bottomDraw(height: 380)))
	}
	
	func didTapFullImageHelp() {
		let vc = PlayerEditHelpViewController.create(mode: .fullImage, delete: {
			self.updateFullImage(nil)
		})
		Popup.show(vc, from: self, options: PopupOptions(.bottomDraw(height: 380)))
	}
}

extension PlayerEditViewController {
	
	private func updateFaceImage(_ image: UIImage?) {
		let face = Image.playerFace(id: player.id)
		face.save(image)
		player.faceImage = image
		
		let thumb = Image.playerThumb(id: player.id)
		thumb.save(image)
		player.thumbImage = image
		
		Realm.Player.notifyChange()
		self.tableView.reloadData()
	}
	
	private func updateFullImage(_ image: UIImage?) {
		let full = Image.playerFull(id: player.id)
		full.save(image)
		player.fullImage = image
		
		self.tableView.reloadData()
	}
}

// MARK: - TableViewDelegate -
protocol PlayerEditTableViewDelegate: class {
	
	func didEditName(value: String)
	func didEditFamilyName(value: String)
	func didEditInternationalName(value: String)
	func didEditShortenedName(value: String)
	func didTapUniformNumber()
	func didTapPosition()
	func didTapFaceImage()
	func didTapFullImage()
	func didTapFaceImageHelp()
	func didTapFullImageHelp()
}

// MARK: - Cells -

// MARK: Base

class PlayerEditTableViewCell: UITableViewCell {
	
	var row: PlayerEditViewController.Row!
	var player: Player!
	weak var delegate: PlayerEditTableViewDelegate?
}

// MARK: - Name

class PlayerEditNameTableViewCell: PlayerEditTableViewCell, UITextFieldDelegate {
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var hintLabel: UILabel!
	@IBOutlet weak var errorLabel: UILabel!
	
	override var row: PlayerEditViewController.Row! {
		didSet {
			textField.placeholder = row.placeholderText
			hintLabel.text = row.hintText
			errorLabel.text = ""
		}
	}
	
	override var player: Player! {
		didSet {
			let row: PlayerEditViewController.Row = self.row
			switch row {
			case .name:              textField.text = player.name
			case .familyName:        textField.text = player.familyName
			case .internationalName: textField.text = player.internationalName
			case .shortenedName:     textField.text = player.shortenedName
			default: break
			}
			switch row {
			case .name:              errorLabel.text = Realm.Player.validateResultOfName(player)
			case .familyName:        errorLabel.text = Realm.Player.validateResultOfFamilyName(player)
			case .internationalName: errorLabel.text = Realm.Player.validateResultOfInternationalName(player)
			case .shortenedName:     errorLabel.text = Realm.Player.validateResultOfShortenedName(player)
			default: break
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.isFirstResponder {
			textField.resignFirstResponder()
		}
		return true
	}
	
	@IBAction private func didChangeTextField() {
		let value = textField.text ?? ""
		let row: PlayerEditViewController.Row = self.row
		switch row {
		case .name:              delegate?.didEditName(value: value)
		case .familyName:        delegate?.didEditFamilyName(value: value)
		case .internationalName: delegate?.didEditInternationalName(value: value)
		case .shortenedName:     delegate?.didEditShortenedName(value: value)
		default: break
		}
	}
}

// MARK: - Input

class PlayerEditInputTableViewCell: PlayerEditTableViewCell {
	
	@IBOutlet weak var textField: UITextField!
	
	override var player: Player! {
		didSet {
			let row: PlayerEditViewController.Row = self.row
			switch row {
			case .uniformNumber: textField.text = player.uniformNumber
			case .position:      textField.text = player.position.rawValue
			default: break
			}
		}
	}
	
	@IBAction private func didTapTextField() {
		let row: PlayerEditViewController.Row = self.row
		switch row {
		case .uniformNumber: delegate?.didTapUniformNumber()
		case .position:      delegate?.didTapPosition()
		default: break
		}
	}
}

// MARK: - Image

class PlayerEditImageTableViewCell: PlayerEditTableViewCell {
	
	@IBOutlet weak var faceImageButton: UIButton!
	@IBOutlet weak var fullImageButton: UIButton!
	
	override var player: Player! {
		didSet {
			faceImageButton.setImage(player.loadFaceImage().faceImage, for: .normal)
			fullImageButton.setImage(player.loadFullImage().fullImage, for: .normal)
		}
	}
	
	@IBAction private func didTapFaceImageButton() {
		delegate?.didTapFaceImage()
	}
	
	@IBAction private func didTapFullImageButton() {
		delegate?.didTapFullImage()
	}
	
	@IBAction private func didTapFaceImageHelpButton() {
		delegate?.didTapFaceImageHelp()
	}
	
	@IBAction private func didTapFullImageHelpButton() {
		delegate?.didTapFullImageHelp()
	}
}
