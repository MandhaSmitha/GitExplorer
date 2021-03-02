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
}

/// Defines attributes specific to search repositories API.
extension GitSearchTarget: NetworkRequest {
    var endpoint: String {
        switch self {
        case .getRepos:
            return "search/repositories"
        }
    }
    var parameters: Params {
        switch self {
        case .getRepos(let params):
            return params
        }
    }
    var method: HttpMethod {
        switch self {
        case .getRepos:
            return .get
        }
    }
    var successResponseFileName: String? {
        switch self {
        case .getRepos:
            return "SearchReposResponse"
        }
    }
}
