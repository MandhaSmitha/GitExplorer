//
//  GItRepoListHeaderView.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

class GItRepoListHeaderView: UITableViewHeaderFooterView {
    @IBOutlet var titleLabel: UILabel!
    
    func bindData(title: String?) {
        titleLabel.text = title
    }
}
