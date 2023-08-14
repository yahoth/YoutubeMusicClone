//
//  MixedForYouCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit
import Kingfisher

class MixedForYouCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 5
    }
    
    func configure(item: PlaylistInfo) {
        let url = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: url)
        titleLabel.text = item.title
        artistsLabel.text = item.description
    }
}
