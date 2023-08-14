//
//  YourMusicTunerDetailCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import UIKit
import Kingfisher

class YourMusicTunerDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        thumbnailImageView.layer.masksToBounds = true
    }

    func configure(item: RelatedArtistsResponse.Artists) {
        let imageURL = URL(string: item.images[0].url)
        thumbnailImageView.kf.setImage(with: imageURL)
        nameLabel.text = item.name
    }
}
