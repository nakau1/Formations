// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit

class EditHeaderTableViewCell: UITableViewCell {
    
    fileprivate static let cellReuseIdentifier = "header"
    
    @IBOutlet fileprivate weak var headerTitleLabel: UILabel!
}

extension UITableView {
    
    func registerEditHeaderCell() {
        self.register(R.nib.editHeaderTableViewCell(), forCellReuseIdentifier: EditHeaderTableViewCell.cellReuseIdentifier)
    }
    
    func dequeueReusableEditHeaderCell(title: String, for indexPath: IndexPath) -> EditHeaderTableViewCell {
        let cell = dequeueReusableCell(withIdentifier: EditHeaderTableViewCell.cellReuseIdentifier, for: indexPath) as! EditHeaderTableViewCell
        cell.headerTitleLabel.text = title
        return cell
    }
}
