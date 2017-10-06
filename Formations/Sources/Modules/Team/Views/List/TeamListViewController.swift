// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class TeamListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var teams: RealmSwift.Results<Team>!
    
    class func create() -> UIViewController {
        return R.storyboard.teamListViewController.instantiate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareObservingNotifications()
        prepareTeams()
    }
    
    private func prepareTeams() {
        teams = Realm.Team.select()
    }
    
    private func prepareObservingNotifications() {
        Realm.Team.observe(self, changeEmblemImage: #selector(didReceiveTeamDidChangeEmblemImage(_:)))
        Realm.Team.observe(self, changeColor: #selector(didReceiveTeamDidChangeColor(_:)))
    }
    
    private func isAddRow(at indexPath: IndexPath) -> Bool {
        return indexPath.row == teams.count
    }
    
    @objc private func didReceiveTeamDidChangeEmblemImage(_ notification: Notification) {
        teams.forEach { _ = $0.loadEmblemImage(force: true) }
        collectionView.reloadData()
    }
    
    @objc private func didReceiveTeamDidChangeColor(_ notification: Notification) {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension TeamListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = R.reuseIdentifier.teamList.reuse(collectionView, indexPath)
        cell.delegate = self
        cell.mode = isAddRow(at: indexPath) ? .add : .team(team: teams[indexPath.row])
        return cell
    }
}

// MARK: - TeamListCollectionViewCellDelegate
extension TeamListViewController: TeamListCollectionViewCellDelegate {
    
    func didTapTeamButton(_ team: Team) {
        push(TeamMenuViewController.create(for: team))
    }
    
    func didTapAddButton() {
        present(TeamEditViewController.create(for: nil).withinNavigation)
    }
}

// MARK: - CellDelegate -
protocol TeamListCollectionViewCellDelegate: class {
    
    func didTapTeamButton(_ team: Team)
    func didTapAddButton()
}

// MARK: - Cell -
class TeamListCollectionViewCell: UICollectionViewCell {
    
    enum Mode {
        case team(team: Team)
        case add
    }
    
    @IBOutlet private weak var emblemButton: CircleImageButton!
    @IBOutlet private weak var nameLabel: UILabel!
    
    weak var delegate: TeamListCollectionViewCellDelegate?
    
    var mode: Mode = .add {
        didSet {
            switch mode {
            case .team(let team):
                emblemButton.borderColor = team.mainColor
                emblemButton.buttonImage = team.loadSmallEmblemImage().smallEmblemImage
                nameLabel.text = team.name
            case .add:
                emblemButton.borderColor = .darkGray
                emblemButton.buttonImage = .addImage
                nameLabel.text = ""
            }
        }
    }
    
    @IBAction private func didTapEmblemButton() {
        switch mode {
        case .team(let team): delegate?.didTapTeamButton(team)
        case .add:            delegate?.didTapAddButton()
        }
    }
}
