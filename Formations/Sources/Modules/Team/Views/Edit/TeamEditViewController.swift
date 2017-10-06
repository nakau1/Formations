// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TeamEditViewController: UIViewController {
    
    // MARK: ファクトリメソッド
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.teamEditViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    enum Row {
        case header(title: String)
        case name
        case internationalName
        case shortenedName
        case color
        case image
        
        static var rows: [Row] {
            return [
                .header(title: "チーム名"),
                .name, .internationalName, .shortenedName,
                .header(title: "チームカラー"),
                .color,
                .header(title: "チーム画像"),
                .image,
            ]
        }
        
        var placeholderText: String {
            switch self {
            case .name:              return "チーム名"
            case .internationalName: return "チーム名(英語表記)"
            case .shortenedName:     return "短縮名"
            default: return ""
            }
        }
        
        var hintText: String {
            switch self {
            case .name:              return "チーム名を入力します\n(\(TeamModel.maxlenOfName)文字以内)"
            case .internationalName: return "チームのの国際上の名称を英字で入力します\n(\(TeamModel.maxlenOfInternationalName)文字以内)"
            case .shortenedName:     return "チームを表す\(TeamModel.fixlenOfShortenedName)文字のアルファベットを入力します\n(例 : 日本代表 = JPN)"
            default: return ""
            }
        }
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var team: Team!
    
    // MARK: ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    private func prepare() {
        prepareNavigationBar()
        prepareBackgroundView()
        prepareTableView()
        prepareTeam()
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
    
    private func prepareTeam() {
        Realm.Team.clearValidateResults(team)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TeamEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.rows[indexPath.row]
        let cell: TeamEditTableViewCell
        
        switch row {
        case .header(let title):
            return tableView.dequeueReusableEditHeaderCell(title: title, for: indexPath)
        case .name, .internationalName:
            cell = R.reuseIdentifier.teamEditName.reuse(tableView)
        case .shortenedName:
            cell = R.reuseIdentifier.teamEditShortName.reuse(tableView)
        case .color:
            cell = R.reuseIdentifier.teamEditColor.reuse(tableView)
        case .image:
            cell = R.reuseIdentifier.teamEditImage.reuse(tableView)
        }
        
        cell.row = row
        cell.team = team
        cell.delegate = self
        return cell
    }
}

// MARK: - TableViewDelegate
extension TeamEditViewController: TeamEditTableViewDelegate {
    
    func didEditName(value: String) {
        if Realm.Team.validateName(value, of: team) {
            Realm.Team.write(team) {
                $0.name = value
            }
        }
        tableView.reloadData()
    }
    
    func didEditInternationalName(value: String) {
        if Realm.Team.validateInternationalName(value, of: team) {
            Realm.Team.write(team) {
                $0.internationalName = value
            }
        }
        tableView.reloadData()
    }
    
    func didEditShortenedName(value: String) {
        if Realm.Team.validateShortenedName(value, of: team) {
            Realm.Team.write(team) {
                $0.shortenedName = value.uppercased()
            }
        }
        tableView.reloadData()
    }
    
    func didTapMainColor() {
        ColorPicker.show(from: self, defaultColor: team.mainColor) { [unowned self] color in
            Realm.Team.write(self.team) { $0.mainColor = color }
            self.tableView.reloadData()
        }
    }
    
    func didTapSubColor() {
        ColorPicker.show(from: self, defaultColor: team.subColor) { [unowned self] color in
            Realm.Team.write(self.team) { $0.subColor = color }
            self.tableView.reloadData()
        }
    }
    
    func didTapOption1Color() {
        
    }
    
    func didTapOption2Color() {
        
    }
    
    func didTapEmblemImage() {
        
    }
    
    func didTapTeamImage() {
        
    }
}

// MARK: - CellDelegate -
protocol TeamEditTableViewDelegate: class {
    
    func didEditName(value: String)
    func didEditInternationalName(value: String)
    func didEditShortenedName(value: String)
    func didTapMainColor()
    func didTapSubColor()
    func didTapOption1Color()
    func didTapOption2Color()
    func didTapEmblemImage()
    func didTapTeamImage()
}

// MARK: - Cells -

// MARK: Base

class TeamEditTableViewCell: UITableViewCell {
    
    var row: TeamEditViewController.Row!
    var team: Team!
    weak var delegate: TeamEditTableViewDelegate?
}

// MARK: - Name

class TeamEditNameTableViewCell: TeamEditTableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override var row: TeamEditViewController.Row! {
        didSet {
            textField.placeholder = row.placeholderText
            hintLabel.text = row.hintText
            errorLabel.text = ""
        }
    }
    
    override var team: Team! {
        didSet {
            let row: TeamEditViewController.Row = self.row
            switch row {
            case .name:              textField.text = team.name
            case .internationalName: textField.text = team.internationalName
            case .shortenedName:     textField.text = team.shortenedName
            default: break
            }
            switch row {
            case .name:              errorLabel.text = Realm.Team.validateResultOfName(team)
            case .internationalName: errorLabel.text = Realm.Team.validateResultOfInternationalName(team)
            case .shortenedName:     errorLabel.text = Realm.Team.validateResultOfShortenedName(team)
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
        let row: TeamEditViewController.Row = self.row
        switch row {
        case .name:              delegate?.didEditName(value: value)
        case .internationalName: delegate?.didEditInternationalName(value: value)
        case .shortenedName:     delegate?.didEditShortenedName(value: value)
        default: break
        }
    }
}

// MARK: - Color

class TeamEditColorTableViewCell: TeamEditTableViewCell {
    
    @IBOutlet var colorButtons: [CircleColorButton]!
    
    override var team: Team! {
        didSet {
            colorButtons.enumerated().forEach { i, button in
                let button = colorButtons[i]
                switch i {
                case 0: button.buttonColor = team.mainColor
                case 1: button.buttonColor = team.subColor
                case 2: button.buttonColor = team.option1Color
                case 3: button.buttonColor = team.option2Color
                default: break
                }
            }
        }
    }
    
    @IBAction private func didTapColorButton(_ colorButton: UIButton) {
        switch colorButton.tag {
        case 0: delegate?.didTapMainColor()
        case 1: delegate?.didTapSubColor()
        case 2: delegate?.didTapOption1Color()
        case 3: delegate?.didTapOption2Color()
        default: break
        }
    }
}

// MARK: - Image

class TeamEditImageTableViewCell: TeamEditTableViewCell {
    
    @IBOutlet weak var emblemImageButton: UIButton!
    @IBOutlet weak var teamImageButton: UIButton!
    
    override var team: Team! {
        didSet {
            emblemImageButton.setImage(team.loadEmblemImage().emblemImage, for: .normal)
            teamImageButton.setImage(team.loadTeamImage().teamImage, for: .normal)
        }
    }
    
    @IBAction private func didTapEmblemImageButton() {
        
    }
    
    @IBAction private func didTapTeamImageButton() {
        
    }
}
