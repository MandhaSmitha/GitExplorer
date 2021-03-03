//
//  GitRepoListResponse.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

// MARK: - GitRepoListResponse
struct GitRepoListResponse: Codable {
    let totalCount: Int?
    var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let itemId: Int?
    let nodeID, name, fullName: String?
    let owner: Owner?
    let itemDescription: String?
    let stargazersCount, watchersCount: Int?
    let language: String?
    let forks, openIssuesCount: Int?

    enum CodingKeys: String, CodingKey {
        case itemId = "id"
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case itemDescription = "description"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case openIssuesCount = "open_issues_count"
        case forks
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let ownerId: Int?
    let nodeID: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case ownerId = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
    }
}
