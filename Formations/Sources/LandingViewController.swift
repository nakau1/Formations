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
            Section("DB", [
                Row("パス", handler: { vc in
                    print("open " + RealmModel.realmPath)
                }),
                Row("オブジェクト生成", handler: { vc in
                    let o = Realm.Team.create()
                    print(o)
                }),
                Row("Fixture 開始", handler: { vc in
                    Fixture.shared.fix()
                }),
                Row("Fixture リセット", handler: { vc in
                    Fixture.shared.reset()
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
