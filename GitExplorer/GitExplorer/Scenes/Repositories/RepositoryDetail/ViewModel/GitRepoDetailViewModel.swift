//
//  GitRepoDetailViewModel.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import Foundation

class GitRepoDetailViewModel {
    let worker: GitSearchWorker
    private var detailModel: GitRepoDetailModel?
    private let detailKeyList = ["Forks", "OpenIssues", "StargazersCount", "LatestRelease"]
    
    init(worker: GitSearchWorker, detailModel: GitRepoDetailModel?) {
        self.worker = worker
        self.detailModel = detailModel
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
                value = detailList.forksCount == nil ? nil : detailList.forksCount!
            case "OpenIssues":
                localizedKey = NSLocalizedString(key, comment: "Number of open issues")
                value = detailList.openIssuesCount == nil ? nil : detailList.openIssuesCount!
            case "StargazersCount":
                localizedKey = NSLocalizedString(key, comment: "Number of stargazers")
                value = detailList.stargazersCount == nil ? nil : detailList.stargazersCount!
            case "LatestRelease":
                localizedKey = NSLocalizedString(key, comment: "Latest release")
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
