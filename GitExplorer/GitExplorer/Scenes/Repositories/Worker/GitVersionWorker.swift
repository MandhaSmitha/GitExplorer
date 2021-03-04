//
//  GitVersionWorker.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 04/03/2021.
//

import Foundation

/// A coordination layer between ViewModel and service or data handlers for any version related services (API or Local).
/// Declare any data or service handlers here.
class GitVersionWorker {
    let serviceProvider: GitVersionServiceProvider
    init(serviceProvider: GitVersionServiceProvider) {
        self.serviceProvider = serviceProvider
    }
}

extension GitVersionWorker: GitVersionWorkerProtocol {
    /// Fetch latest repository version. Talks to the NetworkProvider to call the API.
    /// - Parameters:
    ///   - owner: Name of the repository owner.
    ///   - repoName: Name of the repository.
    ///   - successHandler: Completion handler in case of a success response.
    ///                    Returns status and GitLatestRepoVersionResponse?.
    ///   - failureHandler: Completion handler in case of a failure response. Returns status and the error string.
    func getLatestRepo(owner: String,
                       repoName: String,
                       successHandler: @escaping (Int?, GitLatestRepoVersionResponse?) -> Void,
                       failureHandler: @escaping (Int?, String?) -> Void) {
        serviceProvider.getLatestRepo(owner: owner, repoName: repoName,
                                      successHandler: { (status, response) in
                                        successHandler(status, response)
                                      },
                                      failureHandler: { (status, error) in
                                        failureHandler(status, error)
                                      })
    }
}
