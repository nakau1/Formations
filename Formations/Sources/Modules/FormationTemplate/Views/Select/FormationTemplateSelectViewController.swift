// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class FormationTemplateSelectViewController: UIViewController {
    
    typealias SelectedHandler = (FormationTemplate) -> Void
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var team: Team!
    private var templates: RealmSwift.Results<FormationTemplate>!
    private var selected: SelectedHandler!
    
    class func create(for team: Team, selected: @escaping SelectedHandler) -> UIViewController {
        return R.storyboard.formationTemplateSelectViewController.instantiate(self) { vc in
            vc.team = team
            vc.selected = selected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareTemplates()
    }
    
    private func prepareTemplates() {
        templates = Realm.FormationTemplate.select()
    }
}

extension FormationTemplateSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.formationTemplateSelect, for: indexPath)!
        cell.template = templates[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected(templates[indexPath.row])
        dismiss()
    }
}

class FormationTemplateSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var template: FormationTemplate! {
        didSet {
            formationImageView.image = template.loadImage().image
            titleLabel.text = template.name
        }
    }
}
