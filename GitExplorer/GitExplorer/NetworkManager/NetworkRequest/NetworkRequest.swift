//
//  NetworkRequest.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire
 
typealias Params = Parameters

protocol BaseNetworkRequest {
    var baseUrl: String { get }
    var endpoint: String { get }
    var parameters: Params { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var encoding: ParamEncoding { get }
    var sampleDataString: String? { get }
}
