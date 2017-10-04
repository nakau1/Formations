// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

class ColorPicker: UIViewController {
    
    typealias SelectedHandler = (UIColor) -> Void
    
    private enum Component: Int { case red, green, blue }
    
    private let max = 255
    private let recentColorsCount = 10
    
    @IBOutlet private var sliders: [UISlider]!
    @IBOutlet private var valueLabels: [UILabel]!
    
    @IBOutlet private var sliderButtons: [UIButton]!
    @IBOutlet private var recentButtons: [UIButton]!
    
    @IBOutlet private weak var currentColorButton: UIButton!
    
    @IBOutlet private var hexTextLabels: [UILabel]!
    
    private var selected: SelectedHandler!
    
    // カラーピッカーを表示する
    /// - Parameters:
    ///   - viewController: 表示元のビューコントローラ
    ///   - defaultColor: 初期表示する色
    ///   - selected: 選択時の処理
    class func show(from viewController: UIViewController, defaultColor: UIColor?, selected: @escaping SelectedHandler) {
        let picker = R.storyboard.colorPicker.instantiate(self)
        picker.currentColor = defaultColor ?? UIColor.black
        picker.selected = selected
        
        Popup.show(picker, from: viewController, options: PopupOptions(.rise(offset: nil)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    private var currentColor: UIColor = UIColor.black {
        didSet {
            if !isViewLoaded { return }
			
        }
    }
    
    @IBAction private func didTapMinus(_ button: UIButton) {
        let slider = sliders[button.tag]
        if slider.value > 0 {
            slider.value -= 1
            updateValueLabel(component(button.tag))
            updateBySliders()
        }
    }
    
    @IBAction private func didTapPlus(_ button: UIButton) {
        let slider = sliders[button.tag]
        if slider.value < 255 {
            slider.value += 1
            updateValueLabel(component(button.tag))
            updateBySliders()
        }
    }
    
    @IBAction private func didTapRecent(_ button: UIButton) {
        currentColor = recentButton(button.tag).backgroundColor!
    }
    
    @IBAction private func didChangeSlider(_ slider: UISlider) {
        updateValueLabel(component(slider.tag))
        updateBySliders()
    }
    
    @IBAction private func didTapCurrentColor() {
        
    }
    
    @IBAction private func didTapApply() {
        saveRecentColor(currentColor)
        selected(currentColor)
        dismiss(animated: true) {}
    }
    
    private func updateValueLabel(_ component: Component) {
        valueLabels[component.rawValue].text = "\(Int(sliderValue(component)))"
    }
    
    private func updateSliders(color: UIColor) {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        [r,g,b].enumerated().forEach { i, value in
            slider(component(i)).setValue(Float(Int(value * maxCGFloat)), animated: true)
            updateValueLabel(component(i))
        }
    }
    
    private func updateCurrentColorButton(color: UIColor) {
        currentColorButton.setBackgroundImage(coloredImage(color), for: .normal)
    }
    
    private func updateHexTextLabels(color: UIColor) {
        let hex = hexString(color: color)
        (0..<6).forEach { i in
            hexTextLabel(i).text = hex[i]
        }
    }
    
    private func updateBySliders() {
        let r = sliderValue(.red)   / maxCGFloat
        let g = sliderValue(.green) / maxCGFloat
        let b = sliderValue(.blue)  / maxCGFloat
        currentColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        updateCurrentColorButton(color: currentColor)
        updateHexTextLabels(color: currentColor)
    }
    
    // MARK: - Prepare (on viewDidLoad)
    
    private func prepare() {
        prepareSliderButtons()
        prepareCurrentColor()
        updateRecentColors()
    }
    
    private func prepareSliderButtons() {
        sliderButtons.forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
            $0.layer.borderWidth = 2
            $0.layer.borderColor = $0.titleColor(for: .normal)!.cgColor
        }
    }
    
    private func prepareCurrentColor() {
        updateCurrentColorButton(color: currentColor)
        updateHexTextLabels(color: currentColor)
        updateSliders(color: currentColor)
    }
    
    // MARK: - Recent Colors
    
    private let RecentlyColorsUserDefaultsKey = "ColorPicker.RecentlyUsedColors"
    
    private func updateRecentColors() {
        let colors = loadRecentColors()
        (0..<recentColorsCount).forEach { i in
            recentButton(i).backgroundColor = colors[i]
            recentButton(i).setImage(coloredImage(colors[i]), for: .normal)
        }
    }
    
    private func loadRecentColors() -> [UIColor] {
        let hexStrings: [String] = UserDefaults.standard.array(forKey: RecentlyColorsUserDefaultsKey) as? [String] ?? []
        return (0..<recentColorsCount).map { i -> UIColor in
            return i < hexStrings.count ? color(hexString: hexStrings[i]) : UIColor.gray
        }
    }
    
    private func saveRecentColor(_ color: UIColor) {
        var hexStrings: [String] = UserDefaults.standard.array(forKey: RecentlyColorsUserDefaultsKey) as? [String] ?? []
        hexStrings.insert(hexString(color: color), at: 0)
        if hexStrings.count > recentColorsCount {
            hexStrings.removeLast()
        }
    }
    
    // MARK: - Get Element
    
    private func component(_ int: Int) -> Component {
        return Component(rawValue: int)!
    }
    
    private func slider(_ component: Component) -> UISlider {
        return sliders[component.rawValue]
    }
    
    private func sliderValue(_ component: Component) -> CGFloat {
        return CGFloat(slider(component).value)
    }
    
    private func recentButton(_ tag: Int) -> UIButton {
        guard let ret = (recentButtons.filter { $0.tag == tag }).first else {
            fatalError()
        }
        return ret
    }
    
    private func hexTextLabel(_ tag: Int) -> UILabel {
        guard let ret = (hexTextLabels.filter { $0.tag == tag }).first else {
            fatalError()
        }
        return ret
    }
    
    // MARK: - Utility
    
    private var maxCGFloat: CGFloat {
        return CGFloat(max)
    }
    
    private func hexString(color: UIColor) -> String {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return [r,g,b].reduce("") { res, value in
            let intval = Int(round(value * maxCGFloat))
            return res + (NSString(format: "%02X", intval) as String)
        }
    }
    
    private func color(hexString: String) -> UIColor {
        var color: UInt32 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        if Scanner(string: hexString).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000)   >> 16) / maxCGFloat
            g = CGFloat((color & 0x00FF00)   >>  8) / maxCGFloat
            b = CGFloat( color & 0x0000FF         ) / maxCGFloat
        }
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    private func coloredImage(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 400, height: 300)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        context.restoreGState()
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return ret!
    }
}
