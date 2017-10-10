// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class PlayerSelectViewController: UIViewController {
    
    typealias SelectedHandler = (Player) -> Void
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var team: Team!
    private var players: RealmSwift.Results<Player>!
    private var selected: SelectedHandler!
    
    class func create(for team: Team, selected: @escaping SelectedHandler) -> UIViewController {
        return R.storyboard.playerSelectViewController.instantiate(self) { vc in
            vc.team = team
            vc.selected = selected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        preparePlayers()
    }
    
    private func preparePlayers() {
        players = Realm.Player.select()
    }
}

extension PlayerSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.playerSelect, for: indexPath)!
        cell.player = players[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected(players[indexPath.row])
        dismiss()
    }
}

class PlayerSelectTableViewCell: UnhighlightableTableViewCell {
    
    @IBOutlet private weak var uniformNumberLabel: UILabel!
    @IBOutlet private weak var positionBar: UIView!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    var player: Player? = nil {
        didSet {
            guard let player = self.player else { return }
            uniformNumberLabel.text = player.uniformNumber
            positionLabel.text = player.position.rawValue
            nameLabel.text = player.name
            positionBar.backgroundColor = player.position.backgroundColor
            thumbImageView.image = player.loadThumbImage().thumbImage
        }
    }
}
