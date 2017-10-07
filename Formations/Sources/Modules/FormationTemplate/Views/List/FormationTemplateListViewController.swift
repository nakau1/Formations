// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift
import RealmSwift

// MARK: - Controller Definition -
class FormationTemplateListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    private var team: Team!
    private var templates: RealmSwift.Results<FormationTemplate>!
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.formationTemplateListViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareBackgroundView()
        prepareObservingNotifications()
        prepareTemplates()
    }
    
    func prepareBackgroundView() {
        let image = team.loadTeamImage().teamImage?.retina
        BackgroundView.notifyChangeImage(image)
    }
    
    private func prepareTemplates() {
        templates = Realm.FormationTemplate.select()
    }
    
    private func prepareObservingNotifications() {
        //Realm.FormationTemplate.observe(self, change: #selector(didReceivePlayerChange(notification:)))
    }
    
    @objc private func didReceivePlayerChange(notification: Notification) {
//        players.forEach { _ = $0.loadThumbImage(force: true) }
//        tableView.reloadData()
    }
    
    @IBAction private func didTapAddButton() {
        present(FormationTemplateEditViewController.create(for: nil).withinNavigation)
    }
}

extension FormationTemplateListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.formationTemplateList, for: indexPath)!
        cell.template = templates[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width / 2
        let h = w
        return CGSize(w, h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class FormationTemplateListCell: UICollectionViewCell {
    
    @IBOutlet weak var formationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var template: FormationTemplate! {
        didSet {
            
        }
    }
}
