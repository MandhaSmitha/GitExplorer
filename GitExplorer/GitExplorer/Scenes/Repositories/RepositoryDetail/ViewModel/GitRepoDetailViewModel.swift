//
//  GitRepoDetailViewModel.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import Foundation

class GitRepoDetailViewModel {
    let worker: GitVersionWorkerProtocol
    let parameterModel: GitLatestVersionParameterModel
    var versionResponse: GitLatestRepoVersionResponse?
    private var detailModel: GitRepoDetailModel?
    private let detailKeyList = ["Forks", "OpenIssues", "StargazersCount", "LatestRelease"]
    weak var viewDelegate: GitRepoDetailViewDelegate?
    
    init(worker: GitVersionWorkerProtocol,
         detailModel: GitRepoDetailModel?,
         parameterModel: GitLatestVersionParameterModel) {
        self.worker = worker
        self.detailModel = detailModel
        self.parameterModel = parameterModel
    }
    
    func loadData() {
        getLatestVersion()
    }
    
    /// Gets basic details of the repo.
    /// - Returns: `GitRepoDetailSummaryModel`
    func getSummaryData() -> GitRepoDetailSummaryModel? {
        return detailModel?.summaryModel
    }
    
    /// Constructs a list of key-value pairs for additional details to be displayed from data available.
    /// All details are available in detailModel except latest release which is fetched with an API call.
    /// - Returns: [KeyValueDetailModel] Array of key-value pairs.
    func getDetailList() -> [KeyValueDetailModel]? {
        guard let detailList = detailModel?.detailList else {
            return nil
        }
        var list = [KeyValueDetailModel]()
        for key in detailKeyList {
            var localizedKey, value: String?
            switch key {
            case "Forks":
                localizedKey = NSLocalizedString(key, comment: "Number of forks")
                value = detailList.forksCount!
            case "OpenIssues":
                localizedKey = NSLocalizedString(key, comment: "Number of open issues")
                value = detailList.openIssuesCount!
            case "StargazersCount":
                localizedKey = NSLocalizedString(key, comment: "Number of stargazers")
                value = detailList.stargazersCount
            case "LatestRelease":
                localizedKey = NSLocalizedString(key, comment: "Latest release")
                value = versionResponse?.version
            default:
                break
            }
            if localizedKey != nil && value != nil {
                list.append(KeyValueDetailModel(key: localizedKey!, value: value!))
            }
        }
        return list.count > 0 ? list : nil
    }
}

/* Latest version details */
extension GitRepoDetailViewModel {
    func getLatestVersion() {
        guard let owner = parameterModel.owner, let repo = parameterModel.repoName else {
            return
        }
        worker.getLatestRepo(owner: owner,
                             repoName: repo,
                             successHandler: { [weak self] (_, response) in
                                self?.versionResponse = response
                                self?.viewDelegate?.refreshDetailList()
                             }, failureHandler: {_, _ in })
    }
}
