//
//  NetworkRequest.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire
 
typealias Params = Parameters
typealias NetworkRequest = BaseNetworkRequest

/// Defines the attributes of a network request
protocol BaseNetworkRequest {
    var baseUrl: String { get }
    var endpoint: String { get }
    var parameters: Params { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var encoding: ParamEncoding { get }
    var successResponseFileName: String? { get }
    var failureResponseFileName: String? { get }
}

/// Extension to provide default values for some attributes of `BaseNetworkRequest`
/// Conforming types can use the default values ot override to provide new values
extension BaseNetworkRequest {
    var baseUrl: String {
        return "https://api.github.com/"
    }
    var headers: [String: String] {
        return ["Accept": "application/json"]
    }
    var encoding: ParamEncoding {
        switch self.method {
        case .get:
            return .urlEncoding
        default:
            return .jsonEncoding
        }
    }
    var successResponseFileName: String? {
        return nil
    }
    var failureResponseFileName: String? {
        return nil
    }
}
