//
//  GitVersionWorkerProtocol.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 04/03/2021.
//

import Foundation

/// Worker protocol for Git repo versin APIs.
protocol GitVersionWorkerProtocol {
    func getLatestRepo(owner: String,
                       repoName: String,
                       successHandler: @escaping (Int?, GitLatestRepoVersionResponse?) -> Void,
                       failureHandler: @escaping (Int?, String?) -> Void)
}
