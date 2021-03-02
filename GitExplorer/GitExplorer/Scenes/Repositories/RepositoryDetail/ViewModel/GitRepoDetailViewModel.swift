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
    
    init(worker: GitSearchWorker, detailModel: GitRepoDetailModel?) {
        self.worker = worker
        self.detailModel = detailModel
    }
    
    /// Gets basic details of the repo.
    /// - Returns: `GitRepoDetailSummaryModel`
    func getSummaryData() -> GitRepoDetailSummaryModel? {
        return detailModel?.summaryModel
    }
}
