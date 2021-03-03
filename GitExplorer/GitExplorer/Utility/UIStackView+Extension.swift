//
//  UIStackView+Extension.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

extension UIStackView {
    /// Convinience func to remove all arranged subviews.
    func prepareForReuse() {
        self.arrangedSubviews.forEach { (view) in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
