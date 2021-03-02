//
//  GitSearchTarget.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation

/// Each case is an API to search Git.
enum GitSearchTarget {
    case getRepos(params: Params)
    case getLatestRelease(owner: String, repo: String)
}

/// Defines attributes specific to search repositories API.
extension GitSearchTarget: NetworkRequest {
    var endpoint: String {
        switch self {
        case .getRepos:
            return "search/repositories"
        case .getLatestRelease(let owner, let repo):
            return "repos/\(owner)/\(repo)/releases/latest"
        }
    }
    var parameters: Params {
        switch self {
        case .getRepos(let params):
            return params
        case .getLatestRelease:
            return [:]
        }
    }
    var method: HttpMethod {
        switch self {
        case .getRepos, .getLatestRelease:
            return .get
        }
    }
    var successResponseFileName: String? {
        switch self {
        case .getRepos:
            return "SearchReposResponse"
        case .getLatestRelease:
            return "RepoLatestVersionResponse"
        }
    }
}
