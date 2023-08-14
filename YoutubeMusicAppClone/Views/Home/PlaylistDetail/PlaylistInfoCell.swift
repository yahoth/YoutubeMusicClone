//
//  PlaylistInfoCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import UIKit

import Kingfisher

class PlaylistInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }

    func configure(item: PlaylistInfo) {
        let imageURL = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: imageURL)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
