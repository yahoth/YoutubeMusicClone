//
//  MoreCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import UIKit
import Kingfisher

class MoreCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func configure(item: AnyHashable) {
        if let item = item as? AudioTrack {
            let imageURL = URL(string: item.images[1].url)
            thumbnailImageView.kf.setImage(with: imageURL)
            titleLabel.text = item.title
            subTitleLabel.text = item.artist
            
        } else if let item = item as? PlaylistInfo {
            let imageURL = URL(string: item.imageName)
            thumbnailImageView.kf.setImage(with: imageURL)
            titleLabel.text = item.title
            subTitleLabel.text = item.description
        }
    }
}
