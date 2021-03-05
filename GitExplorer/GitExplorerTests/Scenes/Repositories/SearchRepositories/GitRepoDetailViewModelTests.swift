//
//  GitRepoDetailViewModelTests.swift
//  GitExplorerTests
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import XCTest
@testable import GitExplorer

class GitRepoDetailViewModelTests: XCTestCase {
    var detailViewModel: GitRepoDetailViewModel?
    override func setUpWithError() throws {
        let serviceProvider = GitSearchServiceHandler(networkProvider: MockNetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        let listViewModel = GitRepoViewModel(worker: worker)
        listViewModel.didUpdateSearch("Str")
        let versionServiceProvider = GitVersionServiceHandler(networkProvider: MockNetworkManager())
        let versionWorker = GitVersionWorker(serviceProvider: versionServiceProvider)
        let detailModel = listViewModel.getRepoDetailCellViewModel(row: 0, section: 0)
        let parameterModel = listViewModel.getRepoDetailParameterModel(row: 0, section: 0)
        detailViewModel = GitRepoDetailViewModel(worker: versionWorker,
                                                 detailModel: detailModel,
                                                 parameterModel: parameterModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSummaryData() {
        let data = detailViewModel?.getSummaryData()
        XCTAssertNotNil(data)
        XCTAssertTrue(data?.title == "strapi/strapi-examples")
        XCTAssertTrue(data?.defaultIconName == "DefaultFolderIcon")
        XCTAssertTrue(data?.iconUrl == "https://avatars.githubusercontent.com/u/19872173?v=4")
        XCTAssertTrue(data?.language == "JavaScript")
    }
    func testDetailList() throws {
        /* List count is 3 before the API for latest version is called */
        let list = detailViewModel?.getDetailList()
        XCTAssertTrue(list?.count == 3)
        XCTAssertTrue(list?[0].value == "545")
        XCTAssertTrue(list?[1].value == "22")
        XCTAssertTrue(list?[2].value == "1056")
    }
    func testDetailListWithVersion() throws {
        /* List count is 4 after the API for latest version is called */
        detailViewModel?.loadData()
        let list = detailViewModel?.getDetailList()
        XCTAssertTrue(list?.count == 4)
        XCTAssertTrue(list?[0].value == "545")
        XCTAssertTrue(list?[1].value == "22")
        XCTAssertTrue(list?[2].value == "1056")
        XCTAssertTrue(list?[3].value == "5.0.0")
    }
}
