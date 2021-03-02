//
//  GitRepoDetailCoordinator.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

class GitRepoDetailCoordinator: BaseCoordinator {
    var navigationController: UINavigationController?
    private var detailModel: GitRepoDetailModel?
    
    init(navigationController: UINavigationController?, detailModel: GitRepoDetailModel?) {
        self.navigationController = navigationController
        self.detailModel = detailModel
    }
    
    func start() {
        guard let viewController = GitRepoDetailViewController.instantiate(storyboardName: "Main") else {
            return
        }
        let serviceProvider = GitSearchServiceHandler(networkProvider: NetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        let viewModel = GitRepoDetailViewModel(worker: worker, detailModel: detailModel)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
