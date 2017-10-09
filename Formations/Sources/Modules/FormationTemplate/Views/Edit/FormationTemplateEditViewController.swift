// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class FormationTemplateEditViewController: UIViewController {
    
    class func create(for template: FormationTemplate?) -> UIViewController {
        return R.storyboard.formationTemplateEditViewController.instantiate(self) { vc in
            if let template = template {
                vc.template = template
            } else {
                let newTemplate = Realm.FormationTemplate.create()
                vc.template = newTemplate
                vc.isAdd = true
            }
        }
    }
    
    class var properHeight: CGFloat {
        let controllerViewSize = CGSize(320, 480) // size < iphone5s
        let screenRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let controllerRatio = controllerViewSize.height / controllerViewSize.width
        return controllerViewSize.height * (screenRatio / controllerRatio)
    }
    
    @IBOutlet private weak var positionBoard: PositionBoardView!
    
    private var isAdd = false
    private var template: FormationTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preparePositionBoardView()
        positionBoard.reloadData()
    }
    
    func preparePositionBoardView() {
        positionBoard.pins = template.items.map { item -> PositionBoardPin in
            let view = FormationTemplatePin.create(position: item.position)
            return PositionBoardPin(view: view, percentage: item.percentage)
        }.sorted { a, b in
            return a.percentage < b.percentage
        }
        positionBoard.moved = { [unowned self] pin, i in
            self.didMovedFormationItem(self.template.items[i], percentage: pin.percentage)
        }
    }
    
    @IBAction private func didTapCompleteButton() {
        AlertDialog.showConfirmNewSave(
            from: self,
            targetName: "フォーメーション",
            save: { [unowned self] in
                Realm.FormationTemplate.save(self.template)
                //Realm.FormationTemplate.notifyChange()
                self.dismiss()
            },
            dispose: { [unowned self] in
                Image.delete(category: .formationTemplates, id: self.template.id)
                self.dismiss()
            }
        )
    }
    
    private func didMovedFormationItem(_ item: FormationTemplateItem, percentage: CGPercentage) {
        Realm.FormationTemplate.write(template) { _ in
            item.percentage = percentage
        }
//        Realm.FormationTemplate.write(template) {
//            item.percentage = percentage
//        }
     }
}
