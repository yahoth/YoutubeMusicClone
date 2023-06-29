//
//  CustomMixCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit
import Kingfisher

class CustomMixCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 5
    }
    
    func configure(item: CustomMix) {
        let url = URL(string: item.images[0].url)
        thumbnailImageView.kf.setImage(with: url)
        titleLabel.text = item.name
        artistsLabel.text = item.description
    }
}
