// =============================================================================
//  Formations
//  Copyright 2017 yuichi.nakayasu All rights reserved.
// =============================================================================
import UIKit
import Rswift

extension ReuseIdentifierType where ReusableType: UITableViewCell {
    
    func reuse(_ tableView: UITableView) -> ReusableType {
        return tableView.dequeueReusableCell(withIdentifier: self)!
    }
}
