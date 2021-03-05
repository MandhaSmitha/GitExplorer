//
//  GitSearchReposViewModelTests.swift
//  GitExplorerTests
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import XCTest
@testable import GitExplorer

class GitSearchReposViewModelTests: XCTestCase {
    var viewModel: GitRepoViewModel!

    override func setUpWithError() throws {
        let serviceProvider = GitSearchServiceHandler(networkProvider: MockNetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        viewModel = GitRepoViewModel(worker: worker)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSectionsOnLoad() throws {
        XCTAssertTrue(viewModel.numberOfSections() == 0, "There is no data with the ViewModel upon initialization.")
    }
}
