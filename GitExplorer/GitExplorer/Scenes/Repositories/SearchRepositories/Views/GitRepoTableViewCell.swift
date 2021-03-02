//
//  GitRepoTableViewCell.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit
import Kingfisher

class GitRepoTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Set data to the cell with model, `GitRepoCellViewModel`.
    /// Image is set from the repo url if available. If not, the default Folder Icon is displayed.
    /// - Parameter model: `GitRepoCellViewModel`
    func bindData(model: GitRepoCellViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        if let imageUrl = model.iconUrl, let url = URL(string: imageUrl) {
            iconImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: model.defaultIconName),
                                      options: nil)
        } else {
            iconImageView.image = UIImage(named: model.defaultIconName)
        }
    }
}
