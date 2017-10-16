// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class FormationViewController: UIViewController {
    
    @IBOutlet private weak var positionBoard: PositionBoardView!
    
    private var team: Team!
    private var isDidFirstLayout = false
    private var formation: Formation!
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.formationViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareFormation()
        preparePositionBoardView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isDidFirstLayout {
            reloadPositionBoardView()
            isDidFirstLayout = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Realm.Formation.save(entity: formation, toTeamID: team.id)
    }
    
    private func prepareFormation() {
       formation = Realm.Formation.load(teamID: team.id)
    }
    
    private func preparePositionBoardView() {
        positionBoard.moved = { [unowned self] pin, index in
            self.formation.updatePercentage(pin.percentage, at: index)
        }
        positionBoard.tapped = { [unowned self] pin, index in
            self.didTapPlayer(at: index)
        }
    }
    
    private func reloadPositionBoardView() {
        positionBoard.pins = formation.startingMembers.map { member -> PositionBoardPin in
            let view = FormationPin.create(
                name: member.displayingName,
                borderColor: member.positionColor,
                image: member.memberedPlayer?.thumbImage
            )
            return PositionBoardPin(view: view, percentage: member.percentage)
        }
        positionBoard.reloadData()
    }
    
    @IBAction private func didTapCloseButton() {
        dismiss()
    }
    
    @IBAction private func didTapMenuButton() {
        showRight(controller: FormationMenuViewController.create(delegate: self))
    }
    
    @IBAction private func didTapShareButton() {
        
    }
    
    private func didTapPlayer(at index: Int) {
        let selector = PlayerSelectViewController.create(for: team) { [unowned self] selectedPlayer in
            self.formation.updateStartingMember(to: selectedPlayer, at: index)
            
            let memberedPlayer = self.formation.startingMembers.get(index)!.memberedPlayer!
            let view = self.positionBoard.pins[index].view as! FormationPin
            
            view.setImage(memberedPlayer.thumbImage)
            view.setName(memberedPlayer.displayingName)
            Realm.Formation.save(entity: self.formation, toTeamID: self.team.id)
        }
        showLeft(controller: selector)
    }
    
    @IBAction private func didTapSaveButton() {
        self.dismiss()
    }
    
    private func showLeft(controller: UIViewController) {
        let width = UIScreen.main.bounds.width * 0.8
        show(controller: controller, animation: .leftDraw(width: width))
    }
    
    private func showRight(controller: UIViewController) {
        let width = UIScreen.main.bounds.width * 0.8
        show(controller: controller, animation: .rightDraw(width: width))
    }
    
    private func show(controller: UIViewController, animation: PopupAnimation) {
        var options = PopupOptions(animation)
        options.overlayIsBlur = true
        Popup.show(controller.withinNavigation, from: self, options: options)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension FormationViewController: FormationMenuViewControllerDelegate {
    
    func formationMenuDidSelectFormationText() {
        
    }
    
    func formationMenuDidSelectFormationTemplate() {
        let selector = FormationTemplateSelectViewController.create(for: team) { [unowned self] selectedTemplate in
            self.formation.updateTemplate(selectedTemplate)
            self.reloadPositionBoardView()
            Realm.Formation.save(entity: self.formation, toTeamID: self.team.id)
        }
        showLeft(controller: selector)
    }
    
    func formationMenuDidSelectSubstituteNumber() {
        
    }
    
    func formationMenuDidSelectSkin() {
        
    }
}
