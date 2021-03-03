//
//  GitRepoProviderProtocol.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

/// Composition of protocol to supply relevant data and protocol to handle search updates.
typealias GitRepoProviderProtocol = GitRepoListProviderProtocol & GitRepoSearchProtocol & GitRepoDetailProviderProtocol

/// Any class that provides data for a section from a specific source should conform to this protocol.
protocol GitRepoListProviderProtocol {
    var worker: GitSearchWorkerProtocol { get set }
    var identifier: GitRepoSection { get }
    var delegate: GitRepoViewModelDelegate? { get }
    func numberOfRows() -> Int
    func titleForHeader() -> String?
    func cellViewModel(forRow index: Int) -> Any?
}

/// Protocol to get updates based on search text or get more results when end of one page is reached.
@objc protocol GitRepoSearchProtocol {
    func didUpdateSearch(_ text: String)
    @objc optional func didReachEndOfPage()
}

/// Protocol for repo details.
protocol GitRepoDetailProviderProtocol {
    func getRepoDetail(for index: Int) -> GitRepoDetailModel?
    func getRepoDetailParameterModel(for index: Int) -> GitLatestVersionParameterModel
}
