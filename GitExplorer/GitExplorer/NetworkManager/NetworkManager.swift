//
//  NetworkManager.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire

/// Type for success block
/// -  status: HTTP status code returned from the API call.
/// - response: Success response mapped to the specified model type.
typealias SuccessBlock<T> = (_ status: Int?, _ response: T?) -> Void

/// Type for failure block
/// -  status: HTTP status code returned from the API call.
/// - response: Failure string from the API response.
typealias FailureBlock = (_ status: Int?, _ errorString: String?) -> Void

class NetworkManager: NetworkProvider {
    /// Creates a `DataRequest` with the request attributes provided.
    /// - Parameter request: `NetworkRequest` - Common type for all API requests.
    /// 					  Contains the attributes required to form a `DataRequest`.
    /// - Returns: Alamofire `DataRequest`.
    private func getDataRequest(_ request: NetworkRequest) -> DataRequest {
        let session = SessionHelper.shared.sessionManager
        let dataRequest: DataRequest = session.request(request.baseUrl + request.endpoint,
                                                       method: request.method.value,
                                                       parameters: request.parameters,
                                                       encoding: request.encoding.value,
                                                       headers: HTTPHeaders(request.headers))
        return dataRequest
    }
    
    /// Makes an API call with the attributes of `NetworkRequest`.
    /// - Parameters:
    ///   - request: `NetworkRequest` with the attributes of a specific API call.
    ///   - successModel: Codable model the response needs to be mapped to.
    ///   - successHandler: Completion handler in case of a success response.
    ///   Returns the HTTP status code and optionally response of type T.
    ///   - failureHandler: Completion handler in case of a failure response.
    ///   Return HTTP status code and optionally an error string.
    /// - Returns: Alamofire `DataRequest`.  Use if the calling class needs a reference of the DataRequest.
    func request<T: Codable>(_ request: NetworkRequest,
                             mapToSuccessModel successModel: T.Type,
                             successHandler: @escaping SuccessBlock<T>,
                             failureHandler: @escaping FailureBlock) -> DataRequest? {
        let networkRequest: DataRequest = getDataRequest(request)
        networkRequest.validate().responseData { (response) in
            self.handleResponse(response,
                                successHandler: { (status, responseData) in
                                    successHandler(status, responseData)
                                }, failureHandler: { (status, errorString) in
                                    failureHandler(status, errorString)
                                })
        }
        return networkRequest
    }
    
    /// Handles the response from the API call.
    /// - Parameters:
    ///   - response: response returned by Alamofire.
    ///   - successHandler: Completion handler for in case of a success response.
    ///   Returns the HTTP status code and optionally response of type T.
    ///   - failureHandler: Completion handler in case of a failure response.
    ///   Return HTTP status code and optionally an error string.
    private func handleResponse<T: Codable>(_ response: AFDataResponse<Data>,
                                            successHandler: @escaping SuccessBlock<T>,
                                            failureHandler: @escaping FailureBlock) {
        let statusCode = response.response?.statusCode
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let mappedResponse = try decoder.decode(T.self, from: data)
                successHandler(statusCode, mappedResponse)
            } catch let error {
                failureHandler(statusCode, error.localizedDescription)
                return
            }
        case .failure(let error):
            failureHandler(statusCode, error.localizedDescription)
        }
    }
}
