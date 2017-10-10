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
    private var template: FormationTemplate?
    
    class func create(for team: Team) -> UIViewController {
        return R.storyboard.formationViewController.instantiate(self) { vc in
            vc.team = team
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        preparePositionBoardView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isDidFirstLayout {
            reloadPositionBoardView()
            isDidFirstLayout = true
        }
    }
    
    private func preparePositionBoardView() {
        positionBoard.isMovable = false
    }
    
    private func reloadPositionBoardView() {
        if let template = template {
            positionBoard.pins = template.items.map { item -> PositionBoardPin in
                let view = FormationPin.create(position: item.position)
                return PositionBoardPin(view: view, percentage: item.percentage)
            }
        }
        positionBoard.reloadData()
    }
    
    @IBAction private func didTapCloseButton() {
        self.dismiss()
    }
    
    @IBAction private func didTapFormationTemplateButton() {
        let selector = FormationTemplateSelectViewController.create(for: team)
        let width = UIScreen.main.bounds.width * 0.6
        var options = PopupOptions(.leftDraw(width: width))
        options.overlayIsBlur = true
        Popup.show(selector.withinNavigation, from: self, options: options)
    }
    
    @IBAction private func didTapPlayerButton() {
        let selector = PlayerSelectViewController.create(for: team)
        let width = UIScreen.main.bounds.width * 0.6
        var options = PopupOptions(.leftDraw(width: width))
        options.overlayIsBlur = true
        Popup.show(selector.withinNavigation, from: self, options: options)
    }
    
    @IBAction private func didTapSaveButton() {
        self.dismiss()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
