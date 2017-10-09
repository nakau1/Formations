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
        Realm.FormationTemplate.observe(self, change: #selector(didReceiveFormationTemplateChange(notification:)))
    }
    
    @objc private func didReceiveFormationTemplateChange(notification: Notification) {
        templates.forEach { _ = $0.loadImage(force: true) }
        collectionView.reloadData()
    }
    
    @IBAction private func didTapAddButton() {
        Popup.show(
            FormationTemplateEditViewController.create(for: nil).withinNavigation,
            from: self,
            options: PopupOptions(.bottomDraw(height: FormationTemplateEditViewController.properHeight))
        )
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Popup.show(
            FormationTemplateEditViewController.create(for: templates[indexPath.row]).withinNavigation,
            from: self,
            options: PopupOptions(.bottomDraw(height: FormationTemplateEditViewController.properHeight))
        )
    }
}

class FormationTemplateListCell: UICollectionViewCell {
    
    @IBOutlet weak var formationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var template: FormationTemplate! {
        didSet {
            formationImageView.image = template.loadImage().image
            titleLabel.text = template.name
        }
    }
}
