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
    private var parameterModel: GitLatestVersionParameterModel
    
    init(navigationController: UINavigationController?,
         detailModel: GitRepoDetailModel?,
         parameterModel: GitLatestVersionParameterModel) {
        self.navigationController = navigationController
        self.detailModel = detailModel
        self.parameterModel = parameterModel
    }
    
    func start() {
        guard let viewController = GitRepoDetailViewController.instantiate(storyboardName: "Main") else {
            return
        }
        let serviceProvider = GitSearchServiceHandler(networkProvider: NetworkManager())
        let worker = GitSearchWorker(serviceProvider: serviceProvider)
        let viewModel = GitRepoDetailViewModel(worker: worker,
                                               detailModel: detailModel,
                                               parameterModel: parameterModel)
        viewController.viewModel = viewModel
        viewController.coordinator = self
        viewModel.viewDelegate = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToRepoList() {
        navigationController?.popViewController(animated: true)
    }
}
