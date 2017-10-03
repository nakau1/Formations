// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class LandingViewController: UITableViewController {
    
    var sections: [Section] {
        return [
            Section("アプリ", [
                Row("スタート", handler: { vc in
                    vc.present(TeamEditViewController.create().withinNavigation)
                }),
                ]
            ),
            Section("テスト", [
                Row("テスト画面", handler: { vc in
                    vc.push(TestViewController.create())
                }),
                ]
            ),
            Section("画像", [
                Row("パス", handler: { vc in
                    print(Image.playerFace(id: "hoge").path)
                }),
                Row("リサイズ", handler: { vc in
                    let image = R.image.defaultBackground()!
                    image.resized(to: CGSize(100, 100)).save(.playerFace(id: "gamba"))
                }),
                Row("スケール", handler: { vc in
                    let image = R.image.defaultBackground()!
                    image.scaled(to: CGSize(100, 100)).save(.playerFace(id: "gamba"))
                }),
                Row("クロップ", handler: { vc in
                    let image = R.image.defaultBackground()!
                    image.cropped(to: CGRect(0, 10, 100, 120)).save(.playerFace(id: "gamba"))
                }),
                Row("合成", handler: { vc in
                    let image1 = R.image.defaultBackground()!
                    let image2 = R.image.sampleEmblem1()!
                    image1.synthesized(image: image2).save(.playerFace(id: "gamba"))
                }),
                Row("複数合成", handler: { vc in
                    let image = [
                        R.image.defaultBackground()!,
                        R.image.sampleEmblem1()!,
                        R.image.sampleEmblem2()!,
                        R.image.sampleEmblem3()!
                        ].synthesize()
                    image?.save(.playerFace(id: "gamba"))
                }),
                Row("色埋め", handler: { vc in
                    UIImage.filled(color: .red, size: CGSize(100, 100)).save(.playerFace(id: "gamba"))
                }),
                Row("透明", handler: { vc in
                    UIImage.transparentImage(size: CGSize(345, 456)).save(.playerFace(id: "gamba"))
                }),
                Row("調整", handler: { vc in
                    let image = R.image.defaultBackground()!
                    image.adjusted(to: CGSize(200, 300)).save(.playerFace(id: "gamba"))
                    image.adjusted(to: CGSize(500, 100)).save(.playerFull(id: "gamba"))
                    image.adjusted(to: CGSize(300, 1200)).save(.playerThumb(id: "gamba"))
                }),
                Row("カテゴリ削除", handler: { vc in
                    Image.delete(category: .players, id: "gamba")
                }),
                ]
            ),
        ]
    }
    
    struct Row {
        
        typealias ItemHandler = (UIViewController)->Void
        
        let title: String
        let handler: ItemHandler
        
        init(_ title: String, handler: @escaping ItemHandler) {
            self.title = title
            self.handler = handler
        }
    }
    
    struct Section {
        
        let title: String
        let rows: [Row]
        
        init(_ title: String, _ rows: [Row]) {
            self.title = title
            self.rows = rows
        }
    }
}

extension LandingViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.landing, for: indexPath)!
        cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].rows[indexPath.row].handler(self)
    }
}
