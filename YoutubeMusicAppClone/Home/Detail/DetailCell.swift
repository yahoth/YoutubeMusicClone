//
//  DetailCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/07.
//

import UIKit
import Kingfisher

class DetailCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func configure(item: AnyHashable) {
        if let item = item as? ListenAgain {
            let imageURL = URL(string: item.imageName)
            thumbnailImageView.kf.setImage(with: imageURL)
            titleLabel.text = item.title
            subTitleLabel.text = item.artist
            
        } else if let item = item as? CustomMix {
            let imageURL = URL(string: item.images[0].url)
            thumbnailImageView.kf.setImage(with: imageURL)
            titleLabel.text = item.name
            subTitleLabel.text = item.description
        }
    }
}
