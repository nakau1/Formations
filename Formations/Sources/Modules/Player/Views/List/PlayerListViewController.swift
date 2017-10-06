// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class PlayerListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var team: Team!
    private var players: RealmSwift.Results<Player>!
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.playerListViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareBackgroundView()
        prepareObservingNotifications()
        preparePlayers()
    }
    
    func prepareBackgroundView() {
        let image = team.loadTeamImage().teamImage?.retina
        BackgroundView.notifyChangeImage(image)
    }
    
    private func preparePlayers() {
        players = Realm.Player.select()
    }
    
    private func prepareObservingNotifications() {
        //Realm.Team.observe(self, change: #selector(didReceiveTeamChange(notification:)))
    }
    
    @objc private func didReceivePlayerChange(notification: Notification) {
        //players.forEach { _ = $0.loadSmallEmblemImage(force: true) }
        tableView.reloadData()
    }
}

extension PlayerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.playerList, for: indexPath)!
        cell.player = players[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //push(PlayerEditViewController.create(players[indexPath.row]))
    }
}

class PlayerListTableViewCell: UnhighlightableTableViewCell {
    
    @IBOutlet private weak var uniformNumberLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var internationalNameLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    var player: Player? = nil {
        didSet {
            guard let player = self.player else { return }
            uniformNumberLabel.text = player.uniformNumber
            positionLabel.text = player.position.rawValue
            nameLabel.text = player.name
            internationalNameLabel.text = player.internationalName
            thumbImageView.image = player.loadThumbImage().thumbImage
            
            positionLabel.backgroundColor = player.position.backgroundColor
        }
    }
}
