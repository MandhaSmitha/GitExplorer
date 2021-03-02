//
//  GitReposParameterModel.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation

/// Git search API query parameters model.
/// Reference: https://docs.github.com/en/github/searching-for-information-on-github/searching-for-repositories
struct GitReposParameterModel: Codable {
    var searchQuery: String
    var page: Int
    
    enum CodingKeys: String, CodingKey {
        case searchQuery = "q"
        case page = "page"
    }
}
