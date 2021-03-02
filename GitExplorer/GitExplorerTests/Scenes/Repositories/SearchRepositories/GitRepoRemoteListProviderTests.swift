//
//  GitRepoRemoteListProviderTests.swift
//  GitExplorerTests
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import XCTest
@testable import GitExplorer

class GitRepoRemoteListProviderTests: XCTestCase {
    var remoteListProvider: GitRepoRemoteListProvider!
    var didCallRefreshView: Bool = false
    
    override func setUpWithError() throws {
        let serviceProvider = GitSearchServiceHandler(networkProvider: MockNetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        remoteListProvider = GitRepoRemoteListProvider(worker: worker,
                                                       identifier: .remoteList,
                                                       delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialNumberOfRows() {
        XCTAssertTrue(remoteListProvider.numberOfRows() == 0, "On initialization, there is no API call to fetch data. Response being nil, the rows should be 0")
    }
    func testInitialHeaderTitle() {
        XCTAssertNil(remoteListProvider.titleForHeader())
    }
    func testInitialCellViewModel() {
        XCTAssertNil(remoteListProvider.cellViewModel(forRow: 0))
    }
    func testNumberOfRowsAfterUpdate() {
        /* API gets called when the search string is >= 3 */
        remoteListProvider.didUpdateSearch("Str")
        XCTAssertTrue(remoteListProvider.numberOfRows() == 5)
    }
    func testHeaderTitleAfterUpdate() {
        /* Number of results is the value of the totalCount attribute in the response */
        remoteListProvider.didUpdateSearch("Str")
        XCTAssertTrue(remoteListProvider.titleForHeader() == "431571 results")
    }
    func testCellViewModelAfterUpdate() {
        /* Should return `GitRepoCellViewModel` */
        remoteListProvider.didUpdateSearch("Str")
        XCTAssertNotNil(remoteListProvider.cellViewModel(forRow: 0))
    }
    func testRefreshIsCalledAfterUpdate() {
        /* Once the API call succeeds, the listening delegates should be informed about the updated data */
        remoteListProvider.didUpdateSearch("Str")
        XCTAssertTrue(didCallRefreshView)
    }
    func testResponseDataIsEmptyOnSearchTextDeletion() {
        /* A case where the text is being deleted */
        remoteListProvider.parameterModel.searchQuery = "Str"
        remoteListProvider.didUpdateSearch("St")
        XCTAssertNil(remoteListProvider.repoSearchResponse)
        XCTAssertTrue(didCallRefreshView)
    }
    func testRefreshNotCalledWhenSearchTextCountLessThan3() {
        /* API should not get called when the search text length is less then 3.
         Neither should the listening delegates be informed of an update */
        remoteListProvider.didUpdateSearch("St")
        XCTAssertNil(remoteListProvider.repoSearchResponse)
        XCTAssertFalse(didCallRefreshView)
    }
}

/* Mock `GitRepoViewModelDelegate`. Class listening for data updates. */
extension GitRepoRemoteListProviderTests: GitRepoViewModelDelegate {
    func didReceiveDataUpdate() {
        didCallRefreshView = true
    }
}
