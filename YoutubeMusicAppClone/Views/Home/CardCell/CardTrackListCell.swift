//
//  CardTrackListCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/08/11.
//

import UIKit
import Kingfisher

class CardTrackListCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    func configure(item: AudioTrack) {
        thumbnailImageView.kf.setImage(with: URL(string: item.imageName))
        titleLabel.text = item.title
        subTitleLabel.text = item.artist
    }
}
