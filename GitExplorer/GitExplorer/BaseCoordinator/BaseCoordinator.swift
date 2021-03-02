//
//  BaseCoordinator.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

protocol BaseCoordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}
