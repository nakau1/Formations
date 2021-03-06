// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TeamMenuViewController: UIViewController {
    
    // MARK: ファクトリメソッド
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.teamMenuViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    enum Row {
        case formation
        case formationTemplate
        case players
        case team
        
        static var rows: [Row] {
            return [.formation, .formationTemplate, .players, .team]
        }
        
        var name: String {
            switch self {
            case .formation: return "フォーメーション作成"
            case .formationTemplate: return "フォーメーション雛形作成"
            case .players: return "選手一覧"
            case .team: return "チーム設定"
            }
        }
        
        var summery: String {
            switch self {
            case .formation: return ""
            case .formationTemplate: return "フォーメーションの"
            case .players: return "選手の一覧、追加や編集、削除を行うことができます"
            case .team: return "チームの情報を編集することができます"
            }
        }
        
        var image: UIImage? {
            return nil
        }
        
        func process(_ viewController: UIViewController, team: Team) {
            switch self {
            case .formation:
                viewController.present(FormationViewController.create(for: team))
            case .formationTemplate:
                viewController.push(FormationTemplateListViewController.create(for: team))
            case .players:
                viewController.push(PlayerListViewController.create(for: team))
            case .team:
                viewController.push(TeamEditViewController.create(for: team))
            }
        }
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    func prepare() {
        prepareNavigationBar()
        prepareBackgroundView()
        prepareObservingNotifications()
        title = team.name
    }
    
    func prepareBackgroundView() {
        let image = team.loadTeamImage().teamImage?.retina
        BackgroundView.notifyChangeImage(image)
    }
    
    private func prepareObservingNotifications() {
        Realm.Team.observe(self, change: #selector(didReceiveTeamChange(notification:)))
    }
    
    @objc private func didReceiveTeamChange(notification: Notification) {
        title = team.name
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TeamMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.teamMenu, for: indexPath)!
        cell.menu = Row.rows[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Row.rows[indexPath.row].process(self, team: team)
    }
}

// MARK: - Cell -
class TeamMenuTableViewCell: UnhighlightableTableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var summeryLabel: UILabel!
    @IBOutlet private weak var menuImageView: UIImageView!
    
    var menu: TeamMenuViewController.Row! {
        didSet {
            guard let menu = self.menu else { return }
            nameLabel.text = menu.name
            summeryLabel.text = menu.summery
            menuImageView.image = menu.image
        }
    }
}
