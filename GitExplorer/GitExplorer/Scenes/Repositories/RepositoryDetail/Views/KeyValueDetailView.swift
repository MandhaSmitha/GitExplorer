//
//  KeyValueDetailView.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 02/03/2021.
//

import UIKit

class KeyValueDetailView: UIView {
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var dividerView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let nib = UINib(nibName: "KeyValueDetailView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Couldn't load nib with name, KeyValueDetailView")
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func bindData(key: String, value: String, isDividerHidden: Bool = false) {
        keyLabel.text = key
        valueLabel.text = value
        dividerView.isHidden = isDividerHidden
    }
}
