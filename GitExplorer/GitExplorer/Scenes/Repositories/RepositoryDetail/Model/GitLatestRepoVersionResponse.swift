//
//  GitLatestRepoVersionResponse.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import Foundation

// MARK: - GitLatestRepoVersionResponse
struct GitLatestRepoVersionResponse: Codable {
    let version: String?

    enum CodingKeys: String, CodingKey {
        case version = "tag_name"
    }
}
