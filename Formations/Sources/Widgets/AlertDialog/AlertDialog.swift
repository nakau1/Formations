// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class AlertDialog: UIViewController {
    
    typealias TappedHandler = () -> Void
    
    enum Mode {
        case ok
        case okCancel
        case saveDispose
        case deleteChange
        
        var leftTitle: String? {
            switch self {
            case .ok:           return nil
            case .okCancel:     return "キャンセル"
            case .saveDispose:  return "破棄する"
            case .deleteChange: return "削除する"
            }
        }
        
        var rightTitle: String? {
            switch self {
            case .ok:           return "OK"
            case .okCancel:     return "OK"
            case .saveDispose:  return "保存する"
            case .deleteChange: return "変更する"
            }
        }
        
        var leftStyle: ButtonStyle? {
            switch self {
            case .ok:           return nil
            case .okCancel:     return .default
            case .saveDispose:  return .negative
            case .deleteChange: return .negative
            }
        }
        
        var rightStyle: ButtonStyle? {
            switch self {
            case .ok:           return .default
            case .okCancel:     return .positive
            case .saveDispose:  return .positive
            case .deleteChange: return .default
            }
        }
    }
    
    enum ButtonStyle {
        case `default`
        case positive
        case negative
        
        var color: UIColor {
            switch self {
            case .default:  return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .positive: return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .negative: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        }
    }
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    private var mode: Mode!
    private var message: String!
    private var leftTapped: TappedHandler!
    private var rightTapped: TappedHandler!
    private var leftDismissed: TappedHandler!
    private var rightDismissed: TappedHandler!
    
    class func show(from viewController: UIViewController, message: String, mode: Mode,
                    rightTapped: @escaping TappedHandler = {}, leftTapped: @escaping TappedHandler = {},
                    rightDismissed: @escaping TappedHandler = {}, leftDismissed: @escaping TappedHandler = {}) {
        let alertDialog = R.storyboard.alertDialog.instantiate(self)
        
        alertDialog.message = message
        alertDialog.mode = mode
        alertDialog.leftTapped = leftTapped
        alertDialog.rightTapped = rightTapped
        alertDialog.leftDismissed = leftDismissed
        alertDialog.rightDismissed = rightDismissed
        
        var options = PopupOptions(.rise(offset: nil))
        options.overlayTapDismissalEnabled = false
        options.overlayIsBlur = true
        options.overlayBlurAlpha = 0.95
        
        Popup.show(alertDialog, from: viewController, options: options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareMessage()
        prepareButton(rightButton, style: mode.rightStyle, title: mode.rightTitle)
        prepareButton(leftButton, style: mode.leftStyle, title: mode.leftTitle)
    }
    
    private func prepareView() {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
    }
    
    private func prepareMessage() {
        messageLabel.text = message
    }
    
    private func prepareButton(_ button: UIButton, style: ButtonStyle?, title: String?) {
        let buttonSize = CGSize(100, 44)
        
        if let title = title, let style = style {
            button.setBackgroundImage(UIImage.filled(color: style.color, size: buttonSize), for: .normal)
            button.setTitle(title, for: .normal)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
        } else {
            button.isHidden = true
        }
    }
    
    @IBAction private func didTapLeftButton() {
        leftTapped()
        dismiss(animated: true) {
            self.leftDismissed()
        }
    }
    
    @IBAction private func didTapRightButton() {
        rightTapped()
        dismiss(animated: true) {
            self.rightDismissed()
        }
    }
}
