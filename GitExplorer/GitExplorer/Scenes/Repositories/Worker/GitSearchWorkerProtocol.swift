//
//  GitSearchWorkerProtocol.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation

/// Worker protocol for Git repo search APIs. Works as an interface between the ViewModel and ServiceHandlers.
/// Declare any service or data handling tasks here.
protocol GitSearchWorkerProtocol {
    func getRepositories(parameterModel: GitRepoParameterModel,
                         isNewRequest: Bool,
                         successHandler: @escaping (Int?, GitRepoListResponse?) -> Void,
                         failureHandler: @escaping (Int?, String?) -> Void)
}
