// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class LandingViewController: UITableViewController {
    
    var sections: [Section] {
        return [
            Section("アプリ", [
                Row.init("スタート", handler: { vc in
                    
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
