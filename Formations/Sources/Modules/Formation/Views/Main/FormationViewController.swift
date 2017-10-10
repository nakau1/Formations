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
        positionBoard.tapped = { [unowned self] pin, index in
            self.didTapPlayer(at: index)
        }
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
        let selector = FormationTemplateSelectViewController.create(for: team) { [unowned self] selectedTemplate in
            self.template = selectedTemplate
            self.reloadPositionBoardView()
        }
        show(controller: selector)
    }
    
    private func didTapPlayer(at index: Int) {
        //positionBoard.pins[index]
        
        let selector = PlayerSelectViewController.create(for: team)
        show(controller: selector)
    }
    
    @IBAction private func didTapSaveButton() {
        self.dismiss()
    }
    
    private func show(controller: UIViewController) {
        let width = UIScreen.main.bounds.width * 0.6
        var options = PopupOptions(.leftDraw(width: width))
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
