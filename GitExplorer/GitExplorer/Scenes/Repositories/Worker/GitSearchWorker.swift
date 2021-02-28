//
//  GitSearchWorker.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation

/// A coordination layer between ViewModel and service or data handlers.
/// Declare any data or service handlers here.
class GitSearchWorker {
    let serviceProvider: GitSearchServiceHandler
    init(serviceProvider: GitSearchServiceHandler) {
        self.serviceProvider = serviceProvider
    }
}

extension GitSearchWorker: GitSearchWorkerProtocol {
    /// Makes an API call to fetch repositories with a name cantaining
    /// the search string in the `GitReposParameterModel` model.
    /// - Parameters:
    ///   - parameterModel: Model representing the query parameters required for the search/
    ///   - isNewRequest: `true` if the request is called on change of the search text. `false` in case of pagination.
    ///   - successHandler: Completion handler for in case of a success response.
    ///   					Returns status and GitRepoListResponse?.
    ///   - failureHandler: Completion handler in case of a failure response. Returns status and the error string.
    func getRepositories(parameterModel: GitReposParameterModel, isNewRequest: Bool,
                         successHandler: @escaping (Int?, GitRepoListResponse?) -> Void,
                         failureHandler: @escaping (Int?, String?) -> Void) {
        serviceProvider.getRepositories(parameterModel: parameterModel,
                                        isNewRequest: isNewRequest,
                                        successHandler: { (status, response) in
                                            successHandler(status, response)
                                        },
                                        failureHandler: { (status, error) in
                                            failureHandler(status, error)
                                        })
    }
}
