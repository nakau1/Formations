// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class TeamListViewController: UIViewController {
    
    var teams: RealmSwift.Results<Team>!
    
    // MARK: ファクトリメソッド
    class func create() -> UIViewController {
        return R.storyboard.teamListViewController.instantiate(self) { vc in
            
        }
    }
    
    // MARK: ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
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
        //: TODO
    }
}

// MARK: - Private
private extension TeamListViewController {
    
    /// ビューの初期処理
    func prepare() {
        prepareNavigationBar()
        teams = Realm.Team.select()
    }
    
    func isAddRow(at indexPath: IndexPath) -> Bool {
        return indexPath.row == teams.count
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

