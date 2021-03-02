//
//  GitRepoListHandler.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

/// Provider for remote data list - Calls an API to fetch data on change of search text.
class GitRepoRemoteListProvider {
    var worker: GitSearchWorkerProtocol
    var identifier: GitRepoSection
    weak var delegate: GitRepoViewModelDelegate?
    var repoSearchResponse: GitRepoListResponse?
    var parameterModel: GitReposParameterModel
    
    init(worker: GitSearchWorkerProtocol, identifier: GitRepoSection, delegate: GitRepoViewModelDelegate?) {
        self.worker = worker
        self.identifier = identifier
        self.delegate = delegate
        parameterModel = GitReposParameterModel(searchQuery: "", page: 1)
    }
}

extension GitRepoRemoteListProvider: GitRepoListProviderProtocol {
    func numberOfRows() -> Int {
        return repoSearchResponse?.items?.count ?? 0
    }
    
    /// Title for the section presenting the data is the number of items in the list.
    /// - Returns: Title string.
    /// Mapping from response:
    /// Number of items - totalCount
    func titleForHeader() -> String? {
        guard let count = repoSearchResponse?.totalCount else {
            return nil
        }
        var title = NSLocalizedString("HeaderTitle", comment: "Number of search results")
        title = title.replacingOccurrences(of: "{count}", with: "\(count)")
        return title
    }
    
    /// Returns `GitRepoCellViewModel` with mapped data from the response.
    /// - Parameter index: Index of the item.
    /// - Returns: `GitRepoCellViewModel`
    /// Mapping from response:
    /// title - <owner.login/name>
    /// description - itemDescription
    /// iconUrl - owner.avatarURL
    func cellViewModel(forRow index: Int) -> Any? {
        guard let data = repoSearchResponse?.items?[index] else {
            return nil
        }
        let repoName = data.name ?? ""
        var title = data.owner?.login
        if title == nil {
            title = repoName
        } else {
            title?.append("/\(repoName)")
        }
        let cellViewModel = GitRepoCellViewModel(title: title ?? "",
                                                 description: data.itemDescription,
                                                 defaultIconName: "DefaultFolderIcon",
                                                 iconUrl: data.owner?.avatarURL)
        return cellViewModel
    }
}

extension GitRepoRemoteListProvider: GitRepoSearchProtocol {
    /// Action to handle change on search text.
    ///  Case 1: New text length < 3, old text length < 3
    ///  Action: No action required
    ///  Case 2: New text length < 3, old text length == 3. Text being deleted.
    ///  Action: Clear search results and update the change to listening classes.
    ///  Case 3: New text length >=  3
    ///  Action: Get repo list by calling the API with the new search term.
    /// - Parameter text: New search text
    func didUpdateSearch(_ text: String) {
        if parameterModel.searchQuery.count == 3 && text.count < 3 {
            parameterModel.searchQuery = text
            repoSearchResponse = nil
            delegate?.dataUpdate()
        } else if text.count >= 3 {
            parameterModel.searchQuery = text
            fetchUpdatedData(isNewRequest: true)
        } else {
            parameterModel.searchQuery = text
        }
    }
    
    /// Fetch repo list by calling the API.
    /// - Parameter isNewRequest: `true` in case of change in search text. `false` in case of pagination.
    private func fetchUpdatedData(isNewRequest: Bool = true) {
        worker.getRepositories(parameterModel: parameterModel,
                               isNewRequest: isNewRequest,
                               successHandler: { [weak self] (_, response) in
                                self?.repoSearchResponse = response
                                self?.delegate?.dataUpdate()
                               }, failureHandler: { [weak self] (_, _) in
                                if isNewRequest {
                                    self?.repoSearchResponse = nil
                                    self?.delegate?.dataUpdate()
                                }
                               })
    }
}
