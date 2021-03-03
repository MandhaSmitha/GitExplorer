//
//  GitSearchReposCoordinator.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

class GitSearchReposCoordinator: BaseCoordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let viewController = ViewController.instantiate(storyboardName: "Main") else {
            return
        }
        let serviceProvider = GitSearchServiceHandler(networkProvider: NetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        let viewModel = GitSearchReposViewModel(worker: worker)
        viewModel.viewDelegate = viewController
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: false)
    }
}

extension GitSearchReposCoordinator {
    func navigateToDetail(detailModel: GitRepoDetailModel?, parameterModel: GitLatestVersionParameterModel) {
        let detailCoordinator = GitRepoDetailCoordinator(navigationController: navigationController,
                                                         detailModel: detailModel,
                                                         parameterModel: parameterModel)
        detailCoordinator.start()
    }
}
