//
//  GitRepoViewModel.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

/// Sections w.r.t the view. Add sections here to extend.
enum GitRepoSection {
    case remoteList
}

class GitRepoViewModel {
    var worker: GitSearchWorkerProtocol
    private var repoProviders: [GitRepoProviderProtocol] = [GitRepoProviderProtocol]()
    weak var viewDelegate: GitRepoViewDelegate?
    
    init(worker: GitSearchWorkerProtocol) {
        self.worker = worker
        registerRepoProviders()
    }
    
    /// The UI can have multiple sections with different data sources and UI requirements.
    /// Register different providers for each different section.
    /// All providers conform to `GitRepoProviderProtocol`.
    private func registerRepoProviders() {
        registerRemoteListProvider()
    }
    
    /// Register provider for remote(fetched through an API) Git repo list.
    private func registerRemoteListProvider() {
        let remoteListProvider = GitRepoRemoteListProvider(worker: worker,
                                                           identifier: .remoteList,
                                                           delegate: self)
        repoProviders.append(remoteListProvider)
    }
    
    /// Communicates change in search text to providers.
    /// - Parameter searchText: new searchText.
    func didUpdateSearch(_ searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        repoProviders.forEach { (provider) in
            provider.didUpdateSearch(text)
        }
    }
    
    /// Inform the repo providers that the end of page is reached.
    func didReachEndOfPage() {
        repoProviders.forEach { (provider) in
            provider.didReachEndOfPage?()
        }
    }
}

extension GitRepoViewModel {
    /// Returns number of sections to be displayed based on the data available.
    /// - Returns: Section count.
    func numberOfSections() -> Int {
        var count = 0
        repoProviders.forEach { (dataSource) in
            count += dataSource.numberOfRows() > 0 ? 1 : 0
        }
        return count
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return repoProviders[section].numberOfRows()
    }
    
    func titleForHeader(inSection section: Int) -> String? {
        return repoProviders[section].titleForHeader()
    }
    
    /// Gets the model for the cell from the respective providers.
    /// The type of the model is abstracted by the providers.
    ///  Model can be cast to a specific type depending of the cell using it.
    /// - Parameters:
    ///   - row: Index of the row in section.
    ///   - section: Index of the section
    /// - Returns: Model with relevant data.
    func cellViewModel(forRow row: Int, inSection section: Int) -> Any? {
        return repoProviders[section].cellViewModel(forRow: row)
    }
}

extension GitRepoViewModel: GitRepoViewModelDelegate {
    /// Updates the view to refresh.
    func dataUpdate() {
        viewDelegate?.refreshView()
    }
}

extension GitRepoViewModel {
    /// Gets `GitRepoDetailCellViewModel` from relevant Provider.
    /// - Parameters:
    ///   - row: Index of the row in section.
    ///   - section: Index of the section
    /// - Returns: Model with relevant data.
    func getRepoDetailCellViewModel(row: Int, section: Int) -> GitRepoDetailModel? {
        return repoProviders[section].getRepoDetail(for: row)
    }
    
    /// Gets `GitLatestVersionParameterModel` from relevant Provider.
    /// - Parameters:
    ///   - row: Index of the row in section.
    ///   - section: Index of the section
    /// - Returns: Model with relevant data.
    func getRepoDetailParameterModel(row: Int, section: Int) -> GitLatestVersionParameterModel {
        return repoProviders[section].getRepoDetailParameterModel(for: row)
    }
}
