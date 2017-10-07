// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

// MARK: - Controller Definition -
class FormationTemplateEditViewController: UIViewController {
    
    // MARK: ファクトリメソッド
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
//        positionBoard.moved = { pin, i in
//            print(pin.percentage.x, pin.percentage.y, i)
//        }
        positionBoard.tapped = { pin, i in
            print(pin.percentage.x, pin.percentage.y, i)
        }
    }
}
