//
//  GitSearchServiceProvider.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 04/03/2021.
//

import Foundation

/// Service provider protocol for Git repo search APIs.
protocol GitSearchServiceProvider {
    func getRepositories(parameterModel: GitReposParameterModel,
                         isNewRequest: Bool,
                         successHandler: @escaping (Int?, GitRepoListResponse?) -> Void,
                         failureHandler: @escaping (Int?, String?) -> Void)
}
