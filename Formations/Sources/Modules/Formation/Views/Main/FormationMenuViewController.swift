// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Delegate Protocol -
protocol FormationMenuViewControllerDelegate: class {
    
    func formationMenuDidSelectFormationText()
    
    func formationMenuDidSelectFormationTemplate()
    
    func formationMenuDidSelectSubstituteNumber()
    
    func formationMenuDidSelectSkin()
}

// MARK: - Controller Definition -
class FormationMenuViewController: UIViewController {
    
    class func create(delegate: FormationMenuViewControllerDelegate) -> UIViewController {
        return R.storyboard.formationMenuViewController.instantiate(self) { vc in
            vc.delegate = delegate
        }
    }
    
    enum Row: String {
        case formationText = "テキスト挿入"
        case formationTemplate = "フォーメーション雛形選択"
        case substituteNumber = "交代人数の変更"
        case skin = "スキンの変更"
        
        static var rows: [Row] {
            return [.formationText, .formationTemplate, .substituteNumber, .skin]
        }
        
        func process(_ delegate: FormationMenuViewControllerDelegate) {
            switch self {
            case .formationText:
                delegate.formationMenuDidSelectFormationText()
            case .formationTemplate:
                delegate.formationMenuDidSelectFormationTemplate()
            case .substituteNumber:
                delegate.formationMenuDidSelectSubstituteNumber()
            case .skin:
                delegate.formationMenuDidSelectSkin()
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private weak var delegate: FormationMenuViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FormationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.formationMenu, for: indexPath)!
        cell.textLabel?.text = Row.rows[indexPath.row].rawValue
        cell.imageView?.image = R.image.btnFormation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss {
            Row.rows[indexPath.row].process(self.delegate)
        }
    }
}

// MARK: - Cell -
class FormationMenuTableViewCell: UnhighlightableTableViewCell {
    
}
