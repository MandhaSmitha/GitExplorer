//
//  GitVersionServiceHandler.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 04/03/2021.
//

import Foundation

class GitVersionServiceHandler {
    /// Any class that conforms to `NetworkProvider`
    let networkProvider: NetworkProvider
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

extension GitVersionServiceHandler: GitVersionServiceProvider {
    /// Constructs the `NetworkRequest` to get the latest version of the repository.
    /// - Parameters:
    ///   - owner: Name of the repository owner.
    ///   - repoName: Name of the repository.
    /// - Returns: `NetworkRequest
    private func getLatestRepoVersionTarget(owner: String, repoName: String) -> GitSearchTarget {
        return GitSearchTarget.getLatestRelease(owner: owner, repo: repoName)
    }
    
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
        let request = getLatestRepoVersionTarget(owner: owner, repoName: repoName)
        networkProvider.request(request,
                                mapToSuccessModel: GitLatestRepoVersionResponse.self,
                                successHandler: { (status, response) in
                                    successHandler(status, response)
                                }, failureHandler: { (status, error) in
                                    failureHandler(status, error)
                                })
    }
}
