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
    ///   - successHandler: Completion handler for in case of a success response.
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
