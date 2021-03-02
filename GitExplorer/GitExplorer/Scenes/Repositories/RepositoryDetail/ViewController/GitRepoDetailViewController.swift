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
    @IBOutlet var detailContainer: UIView!
    @IBOutlet var detailStackView: UIStackView!
    var viewModel: GitRepoDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSummaryView()
        setupDetailView()
    }
    
}

/* Basic info section */
extension GitRepoDetailViewController {
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
}

/* Additional Details section */
extension GitRepoDetailViewController {
    func setupDetailView() {
        guard let detailList = viewModel?.getDetailList() else {
            return
        }
        detailStackView.prepareForReuse()
        detailStackView.addArrangedSubview(getSpacerView())
        for index in 0..<detailList.count {
            let item = detailList[index]
            let view = KeyValueDetailView()
            view.bindData(key: item.key,
                          value: item.value,
                          isDividerHidden: index == detailList.count - 1)
            detailStackView.addArrangedSubview(view)
        }
        detailStackView.addArrangedSubview(getSpacerView())
        setupDetailContainer()
    }
    
    private func setupDetailContainer() {
        detailContainer.layer.cornerRadius = 6.0
        detailContainer.layer.borderWidth = 0.5
        detailContainer.layer.borderColor = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1).cgColor
    }
    
    private func getSpacerView() -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        return view
    }
}
