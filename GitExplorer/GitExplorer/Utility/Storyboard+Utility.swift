//
//  Storyboard+Utility.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName: String) -> Self?
}

extension Storyboarded where Self: UIViewController {
    /// Instantiate and return a view controller. Uses the class name as the identifier.
    /// - Returns: Instantiated view controller.
    static func instantiate(storyboardName: String) -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
}
