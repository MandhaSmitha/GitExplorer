//
//  GitRepoDetailViewController.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit
import Kingfisher

class GitRepoDetailViewController: UIViewController, Storyboarded {
    @IBOutlet var summaryStackView: UIStackView!
    @IBOutlet var iconView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var detailStackView: UIStackView!
    var viewModel: GitRepoDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSummaryView()
        setupDetailView()
    }
    
    func setupSummaryView() {
        guard let model = viewModel?.getSummaryData() else {
            return
        }
        iconView.layer.cornerRadius = 6.0
        summaryStackView.setCustomSpacing(14.0, after: iconView)
        if let imageUrl = model.iconUrl, let url = URL(string: imageUrl) {
            iconImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: model.defaultIconName))
            iconImageView.contentMode = .scaleAspectFit
        } else {
            iconImageView.image = UIImage(named: model.defaultIconName)
            iconImageView.contentMode = .center
        }
        titleLabel.text = model.title
        languageLabel.text = model.language
    }
    
    func setupDetailView() {
        detailStackView.prepareForReuse()
    }
}
