//
//  GitVersionServiceProvider.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 04/03/2021.
//

import Foundation

/// Service provider protocol for Git repo version APIs.
protocol GitVersionServiceProvider {
    func getLatestRepo(owner: String,
                       repoName: String,
                       successHandler: @escaping (Int?, GitLatestRepoVersionResponse?) -> Void,
                       failureHandler: @escaping (Int?, String?) -> Void)
}
