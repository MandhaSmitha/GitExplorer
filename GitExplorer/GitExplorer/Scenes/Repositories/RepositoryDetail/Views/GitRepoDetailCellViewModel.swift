//
//  GitRepoDetailCellViewModel.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import Foundation

/* Model for the Repository detail screen */
struct GitRepoDetailCellViewModel {
    let summaryModel: GitRepoDetailSummaryModel
    let detailList: GitRepoDetailsListModel?
}

struct GitRepoDetailSummaryModel {
    let title: String
    let defaultIconName: String
    let iconUrl: String?
    let language: String?
}

struct GitRepoDetailsListModel {
    let forksCount: String?
    let openIssuesCount: String?
    let stargazersCount: String?
    var lastReleaseVersion: String?
    
    init(forksCount: String?,
         openIssuesCount: String?,
         stargazersCount: String?,
         lastReleaseVersion: String? = nil) {
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.stargazersCount = stargazersCount
        self.lastReleaseVersion = lastReleaseVersion
    }
}
