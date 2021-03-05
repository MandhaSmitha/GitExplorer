//
//  GitSearchServiceHandlerTests.swift
//  GitExplorerTests
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import XCTest
@testable import GitExplorer

class GitSearchServiceHandlerTests: XCTestCase {
    var serviceHandler: GitSearchServiceHandler!
    override func setUpWithError() throws {
        let networkProvider = MockNetworkManager()
        serviceHandler = GitSearchServiceHandler(networkProvider: networkProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRepositoriesResponse() throws {
        var response: GitRepoListResponse?
        let parameterModel = GitRepoParameterModel(searchQuery: "str", page: 1)
        serviceHandler.getRepositories(parameterModel: parameterModel,
                                       isNewRequest: true,
                                       successHandler: { (status, data) in
                                            response = data
                                       },
                                       failureHandler: {_,_ in })
        XCTAssertNotNil(response)
    }
}
