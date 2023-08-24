//
//  ListenAgainCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import Kingfisher

class ListenAgainCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func configure(item: AudioTrack) {
        let url = URL(string: item.images[1].url)
        thumbnailImageView.kf.setImage(with: url)
        titleLabel.text = item.title
    }
}
