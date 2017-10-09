// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class FormationListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var team: Team!
    private var formations: RealmSwift.Results<Formation>!
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.formationListViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareBackgroundView()
        prepareTableView()
        prepareObservingNotifications()
        prepareFormations()
    }
    
    func prepareBackgroundView() {
        let image = team.loadTeamImage().teamImage?.retina
        BackgroundView.notifyChangeImage(image)
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func prepareFormations() {
        formations = Realm.Formation.select()
    }
    
    private func prepareObservingNotifications() {
//        Realm.Formation.observe(self, change: #selector(didReceiveFormationChange(notification:)))
    }
    
    @objc private func didReceiveFormationChange(notification: Notification) {
//        formations.forEach { _ = $0.loadThumbImage(force: true) }
        tableView.reloadData()
    }
    
    @IBAction private func didTapAddButton() {
//        present(PlayerEditViewController.create(for: nil, ofTeam: team).withinNavigation)
    }
}

extension FormationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20//formations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.formationList, for: indexPath)!
        //cell.formation = formations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        push(PlayerEditViewController.create(for: players[indexPath.row], ofTeam: team))
    }
}

class FormationListTableViewCell: UnhighlightableTableViewCell {
    
    @IBOutlet private weak var uniformNumberLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var internationalNameLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    var formation: Formation? = nil {
        didSet {
            
        }
    }
}

