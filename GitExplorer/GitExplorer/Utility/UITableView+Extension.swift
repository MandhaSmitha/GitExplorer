//
//  UITableView+Extension.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque TableViewCell")
        }
        return cell
    }
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Unable to deque TableViewCell")
        }
        return view
    }
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) {
        let nib = UINib(nibName: headerFooterViewType.reuseIdentifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
}
