//
//  NetworkProvider.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire

/// Protocol for the common Network provider. Uses the Alamofire framework to make and handle API calls.
/// Parses the response into any type that conforms to Codable.
protocol NetworkProvider {
    @discardableResult func request<T: Codable>(_ request: NetworkRequest,
                                                mapToSuccessModel successModel: T.Type,
                                                successHandler: @escaping SuccessBlock<T>,
                                                failureHandler: @escaping FailureBlock) -> DataRequest?
}
