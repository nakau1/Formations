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
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var positionNumberArea: UIView!
    @IBOutlet private weak var dfNumberLabel: UILabel!
    @IBOutlet private weak var mfNumberLabel: UILabel!
    @IBOutlet private weak var fwNumberLabel: UILabel!
    
    private var isAdd = false
    private var isDidFirstLayout = false
    private var template: FormationTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareNameTextField()
        preparePositionNumber()
        preparePositionBoardView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isDidFirstLayout {
            reloadPositionBoardView()
            isDidFirstLayout = true
        }
    }
    
    private func prepareNameTextField() {
        nameTextField.text = template.name
    }
    
    private func preparePositionNumber() {
        updatePositionNumber(template.structure)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPositionNumberArea))
        positionNumberArea.addGestureRecognizer(gesture)
    }
    
    private func preparePositionBoardView() {
        positionBoard.moved = { [unowned self] pin, i in
            self.didMovedFormationItem(self.template.items[i], percentage: pin.percentage)
        }
    }
    
    private func updatePositionNumber(_ structure: [Position : Int]) {
        dfNumberLabel.text = "\(structure[.defender]   ?? 0)"
        mfNumberLabel.text = "\(structure[.midfielder] ?? 0)"
        fwNumberLabel.text = "\(structure[.forward]    ?? 0)"
    }
    
    private func reloadPositionBoardView() {
        positionBoard.pins = template.items.map { item -> PositionBoardPin in
            let view = FormationTemplatePin.create(position: item.position)
            return PositionBoardPin(view: view, percentage: item.percentage)
        }
        positionBoard.reloadData()
    }
    
    @IBAction private func didTapCompleteButton() {
        AlertDialog.showConfirmNewSave(
            from: self,
            targetName: "フォーメーション",
            save: { [unowned self] in
                Realm.FormationTemplate.write(self.template) {
                    $0.name = self.nameTextField.textValue
                }
                Realm.FormationTemplate.save(self.template)
                Realm.FormationTemplate.notifyChange()
                self.dismiss()
            },
            dispose: { [unowned self] in
                Image.delete(category: .formationTemplates, id: self.template.id)
                self.dismiss()
            }
        )
    }
    
    @objc private func didTapPositionNumberArea() {
        PositionNumberPicker.show(from: self, defaultValues: template.structure) { [unowned self] newStructure in
            self.updatePositionNumber(newStructure)
            Realm.FormationTemplate.write(self.template) {
                $0.structure = newStructure
            }
            self.reloadPositionBoardView()
        }
    }
    
    private func didMovedFormationItem(_ item: FormationTemplateItem, percentage: CGPercentage) {
        Realm.FormationTemplate.write(template) { _ in
            item.percentage = percentage
        }
     }
}

extension FormationTemplateEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction private func didChangeNameTextField(_ textField: UITextField) {
        if !Realm.FormationTemplate.validateName(textField.textValue, of: template) {
            textField.textValue = textField.textValue[0, FormationTemplateModel.maxlenOfName]
        }
    }
}
