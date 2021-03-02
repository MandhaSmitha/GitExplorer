//
//  GitRepoViewDelegate.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import Foundation

/// Protocol for the Repo list view to get notified when there is an update in data and view needs to be refreshed.
protocol GitRepoViewDelegate: class {
    func refreshView()
}
