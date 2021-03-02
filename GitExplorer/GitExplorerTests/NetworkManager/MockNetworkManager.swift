//
//  MockNetworkManager.swift
//  GitExplorerTests
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation
import Alamofire
@testable import GitExplorer

/// NetworkManager to be used only for unit tests.
class MockNetworkManager: NetworkProvider {
    func request<T: Codable>(_ request: NetworkRequest,
                    mapToSuccessModel successModel: T.Type,
                    successHandler: @escaping SuccessBlock<T>,
                    failureHandler: @escaping FailureBlock) -> DataRequest? {
        guard let fileName = request.successResponseFileName,
              let response = FileUtility().getCodable(bundle: Bundle(for: MockNetworkManager.self), fromFile: fileName,
                                                      type: "json",
                                                      mapToModel: successModel.self) else {
            failureHandler(nil, "Could not fetch data")
            return nil
        }
        successHandler(nil, response)
        return nil
    }
}
