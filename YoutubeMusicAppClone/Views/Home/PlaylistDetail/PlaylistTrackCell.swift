//
//  PlaylistTrackCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import UIKit

import Kingfisher

class PlaylistTrackCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }

    func configure(item: AudioTrack) {
        let imageURL = URL(string: item.images[2].url)
        thumbnailImageView.kf.setImage(with: imageURL)
        titleLabel.text = item.title
        subtitleLabel.text = item.artist
    }
}
