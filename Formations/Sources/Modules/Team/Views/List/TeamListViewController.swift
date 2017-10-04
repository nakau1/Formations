// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class TeamListViewController: UIViewController {
    
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

// MARK: - Private -
private extension TeamListViewController {
    
    /// ビューの初期処理
    func prepare() {
        prepareNavigationBar()
    }
}

class TeamListCollectionViewCell: UICollectionViewCell {

}

/*
class TeamListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var teams = [Team]()
    
    class func create() -> UIViewController {
        return R.storyboard.teamList.instantiate(self).withinNavigation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

extension TeamListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.teamList, for: indexPath)!
        cell.delegate = self
        cell.mode = isAddRow(at: indexPath) ? .add : .team(team: teams[indexPath.row])
        return cell
    }
}

extension TeamListViewController: TeamListCollectionViewCellDelegate {
    
    func didTapTeamButton(_ team: Team) {
        push(TeamMenuViewController.create(team))
    }
    
    func didTapAddButton() {
        //: TODO
    }
}

private extension TeamListViewController {
    
    func prepare() {
        prepareNavigationBar()
        teams = App.Model.Team.select().toArray()
        collectionView.reloadData()
    }
    
    func isAddRow(at indexPath: IndexPath) -> Bool {
        return indexPath.row == teams.count
    }
}

protocol TeamListCollectionViewCellDelegate: class {
    
    func didTapTeamButton(_ team: Team)
    
    func didTapAddButton()
}

class TeamListCollectionViewCell: UICollectionViewCell {
    
    enum Mode {
        case team(team: Team)
        case add
    }
    
    @IBOutlet private weak var emblemButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    
    weak var delegate: TeamListCollectionViewCellDelegate?
    
    var mode: Mode = .add {
        didSet {
            switch mode {
            case .team(let team):
                setupEmblemButton(image: R.image.sample1())
                setupNameLabel(text: team.name)
                setupEmblemButton(color: team.mainColor)
            case .add:
                setupEmblemButton(image: R.image.sample4())
                setupNameLabel(text: nil)
                setupEmblemButton(color: UIColor.black)
            }
        }
    }
    
    @IBAction private func didTapEmblemButton() {
        switch mode {
        case .team(let team): delegate?.didTapTeamButton(team)
        case .add:            delegate?.didTapAddButton()
        }
    }
    
    private func setupNameLabel(text: String?) {
        nameLabel.text = text
        nameLabel.shadowColor = UIColor.black
        nameLabel.shadowOffset = CGSize(0, 1)
    }
    
    private func setupEmblemButton(image: UIImage?) {
        emblemButton.setImage(image, for: .normal)
    }
    
    private func setupEmblemButton(color: UIColor) {
        emblemButton.layer.cornerRadius = emblemButton.bounds.width / 2
        emblemButton.layer.borderWidth = 2
        emblemButton.layer.borderColor = color.withAlphaComponent(0.75).cgColor
        emblemButton.backgroundColor = color.withAlphaComponent(0.2)
    }
}
*/
