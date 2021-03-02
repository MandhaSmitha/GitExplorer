//
//  GitRepoViewModelDelegate.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

/// Repo list providers update changes to the data based on search text through this protocol.
protocol GitRepoViewModelDelegate: class {
    func dataUpdate()
}
