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
        
        var leftTitle: String? {
            switch self {
            case .ok:          return nil
            case .okCancel:    return "キャンセル"
            case .saveDispose: return "破棄する"
            }
        }
        
        var rightTitle: String? {
            switch self {
            case .ok:          return "OK"
            case .okCancel:    return "OK"
            case .saveDispose: return "保存する"
            }
        }
        
        var leftStyle: ButtonStyle? {
            switch self {
            case .ok:          return nil
            case .okCancel:    return .default
            case .saveDispose: return .negative
            }
        }
        
        var rightStyle: ButtonStyle? {
            switch self {
            case .ok:          return .default
            case .okCancel:    return .positive
            case .saveDispose: return .positive
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
    
    class func show(from viewController: UIViewController, message: String, mode: Mode, rightTapped: @escaping TappedHandler, leftTapped: @escaping TappedHandler) {
        let alertDialog = R.storyboard.alertDialog.instantiate(self)
        
        alertDialog.message = message
        alertDialog.mode = mode
        alertDialog.leftTapped = leftTapped
        alertDialog.rightTapped = rightTapped
        
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
        prepareButton()
    }
    
    private func prepareView() {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
    }
    
    private func prepareMessage() {
        messageLabel.text = message
    }
    
    private func prepareButton() {
        let buttonSize = CGSize(100, 44)
        
        if let rightTitle = mode.rightTitle, let rightStyle = mode.rightStyle {
            rightButton.setBackgroundImage(UIImage.filled(color: rightStyle.color, size: buttonSize), for: .normal)
            rightButton.setTitle(rightTitle, for: .normal)
            rightButton.layer.cornerRadius = 5
            rightButton.clipsToBounds = true
        } else {
            rightButton.isHidden = true
        }

        if let leftTitle = mode.leftTitle, let leftStyle = mode.leftStyle {
            leftButton.setBackgroundImage(UIImage.filled(color: leftStyle.color, size: buttonSize), for: .normal)
            leftButton.setTitle(leftTitle, for: .normal)
            leftButton.layer.cornerRadius = 5
            leftButton.clipsToBounds = true
        } else {
            leftButton.isHidden = true
        }
    }
    
    @IBAction private func didTapLeftButton() {
        leftTapped()
        dismiss(animated: true) {}
    }
    
    @IBAction private func didTapRightButton() {
        rightTapped()
        dismiss(animated: true) {}
    }
}
