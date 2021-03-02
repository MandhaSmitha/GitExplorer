//
//  GitSearchServiceHandler.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire

class GitSearchServiceHandler {
    /// Any class that conforms to `NetworkProvider`
    let networkProvider: NetworkProvider
    /// Need to save a reference to the DataRequest to cancel an ongoing search API call if the search term has changed.
    private var dataRequest: DataRequest?
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

extension GitSearchServiceHandler {
    /// Constructs the `NetworkRequest` to search GIt repos with a specific search term.
    /// - Parameter parameterModel: Contains the query parameters required for the Git repos search API call.
    /// - Returns: `NetworkRequest`
    private func getGitSearchReposTarget(parameterModel: GitReposParameterModel) -> GitSearchTarget? {
        do {
            let parameters = try parameterModel.toDictionary()
            return GitSearchTarget.getRepos(params: parameters)
        } catch {
            return nil
        }
    }
    
    /// Fetch repositories from GIt. Talks to the NetworkProvider to call the API.
    /// - Parameters:
    /// - Parameter parameterModel: Contains the query parameters required for the Git repos search API call.
    ///   - isNewRequest: `true` if the request is called on change of the search text. `false` in case of pagination.
    ///   - successHandler: Completion handler in case of a success response.
    ///   				 Returns status and GitRepoListResponse?.
    ///   - failureHandler: Completion handler in case of a failure response. Returns status and the error string.
    func getRepositories(parameterModel: GitReposParameterModel,
                         isNewRequest: Bool,
                         successHandler: @escaping (Int?, GitRepoListResponse?) -> Void,
                         failureHandler: @escaping (Int?, String?) -> Void) {
        if isNewRequest {
            dataRequest?.cancel()
        }
        guard let request = getGitSearchReposTarget(parameterModel: parameterModel) else {
            failureHandler(nil, nil)
            return
        }
        dataRequest = networkProvider.request(request,
                                              mapToSuccessModel: GitRepoListResponse.self,
                                              successHandler: { (status, response) in
                                                successHandler(status, response)
                                              }, failureHandler: { (status, error) in
                                                failureHandler(status, error)
                                              })
    }
}

extension GitSearchServiceHandler {
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
        dataRequest = networkProvider.request(request,
                                              mapToSuccessModel: GitLatestRepoVersionResponse.self,
                                              successHandler: { (status, response) in
                                                successHandler(status, response)
                                              }, failureHandler: { (status, error) in
                                                failureHandler(status, error)
                                              })
    }
}
