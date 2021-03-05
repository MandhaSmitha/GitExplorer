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
    var parameterModel: GitRepoParameterModel
    var isLoading = false
    
    init(worker: GitSearchWorkerProtocol, identifier: GitRepoSection, delegate: GitRepoViewModelDelegate?) {
        self.worker = worker
        self.identifier = identifier
        self.delegate = delegate
        parameterModel = GitRepoParameterModel(searchQuery: "", page: 1)
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
        let title = getTitle(data: data)
        let cellViewModel = GitRepoCellViewModel(title: title,
                                                 description: data.itemDescription,
                                                 defaultIconName: "DefaultFolderIcon",
                                                 iconUrl: data.owner?.avatarURL)
        return cellViewModel
    }
    
    private func getTitle(data: Item) -> String {
        let repoName = data.name ?? ""
        var title = data.owner?.login
        if title == nil {
            title = repoName
        } else {
            title?.append("/\(repoName)")
        }
        return title ?? ""
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
        parameterModel.page = 1
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
    
    /// If an api call is not already in progress and the end of page is reached, call the api with incremented page no.
    /// Check if all items in the list are already available.
    /// Total count is available in the response attribute `totalCount`.
    /// Do not call the api if all the items are already fetched.
    func didReachEndOfPage() {
        guard let items = repoSearchResponse?.items,
              let totalCount = repoSearchResponse?.totalCount else {
            return
        }
        if !isLoading && items.count != totalCount {
            parameterModel.page += 1
            fetchUpdatedData(isNewRequest: false)
        }
    }
    
    /// Fetch repo list by calling the API. Reset response in case of change of searchText and append if it's paginatin.
    /// - Parameter isNewRequest: `true` in case of change in search text. `false` in case of pagination.
    private func fetchUpdatedData(isNewRequest: Bool = true) {
        isLoading = true
        worker.getRepositories(parameterModel: parameterModel,
                               isNewRequest: isNewRequest,
                               successHandler: { [weak self] (_, response) in
                                self?.isLoading = false
                                if isNewRequest {
                                    self?.repoSearchResponse = response
                                } else if let items = response?.items {
                                    self?.repoSearchResponse?.items?.append(contentsOf: items)
                                }
                                self?.delegate?.dataUpdate()
                               }, failureHandler: { [weak self] (_, _) in
                                self?.isLoading = false
                                if isNewRequest {
                                    self?.repoSearchResponse = nil
                                    self?.delegate?.dataUpdate()
                                } else {
                                    self?.resetPage()
                                }
                               })
    }
    
    /// If the api fails while fetching paginated results, reset page number to the one previous.
    private func resetPage() {
        parameterModel.page -= 1
    }
}

extension GitRepoRemoteListProvider: GitRepoDetailProviderProtocol {
    /// Creates a repository detail model.
    /// - Parameter index: Index of the item required to be converted to `GitRepoDetailCellViewModel`.
    /// - Returns: `GitRepoDetailCellViewModel` with the details mapped from Item data.
    func getRepoDetail(for index: Int) -> GitRepoDetailModel? {
        guard let data = repoSearchResponse?.items?[index] else {
            return nil
        }
        let summaryModel = getSummaryModel(data: data)
        let listModel = getDetailsListModel(data: data)
        let cellViewModel = GitRepoDetailModel(summaryModel: summaryModel,
                                                       detailList: listModel)
        return cellViewModel
    }
    
    /// Creates a model with the basic details of a repository.
    /// - Parameter data: `Item` model with data needed to construct `GitRepoDetailSummaryModel`.
    /// - Returns: `GitRepoDetailSummaryModel` with the details mapped from item data.
    private func getSummaryModel(data: Item) -> GitRepoDetailSummaryModel {
        let summaryModel = GitRepoDetailSummaryModel(title: getTitle(data: data),
                                                     defaultIconName: "DefaultFolderIcon",
                                                     iconUrl: data.owner?.avatarURL,
                                                     language: data.language)
        return summaryModel
    }
    
    /// Creates a list model with extra details of a repository.
    /// - Parameter data: `Item` model with data needed to construct `GitRepoDetailsListModel`.
    /// - Returns: `GitRepoDetailsListModel` with the details mapped from item data.
    private func getDetailsListModel(data: Item) -> GitRepoDetailsListModel {
        let forks = data.forks == nil ? "" : "\(data.forks!)"
        let openIssuesCount = data.openIssuesCount == nil ? "" : "\(data.openIssuesCount!)"
        let stargazersCount = data.stargazersCount == nil ? "" : "\(data.stargazersCount!)"
        let detailListModel = GitRepoDetailsListModel(forksCount: forks,
                                                      openIssuesCount: openIssuesCount,
                                                      stargazersCount: stargazersCount)
        return detailListModel
    }
    
    /// Constructs the parameterModel needed to fetch the latestRepoVersion.
    /// - Parameter index: Index of the item required to construct `GitLatestVersionParameterModel.`
    /// - Returns: `GitLatestVersionParameterModel` with the required parameters.
    func getRepoDetailParameterModel(for index: Int) -> GitLatestVersionParameterModel {
        guard let data = repoSearchResponse?.items?[index] else {
            return GitLatestVersionParameterModel(owner: nil, repoName: nil)
        }
        return GitLatestVersionParameterModel(owner: data.owner?.login,
                                              repoName: data.name)
    }
}
