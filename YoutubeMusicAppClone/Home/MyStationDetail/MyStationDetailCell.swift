//
//  MyStationDetailCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import UIKit
import Kingfisher

class MyStationDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 55
    }
    
    func configure(item: RelatedArtistsResponse.Artists) {
        let imageURL = URL(string: item.images[0].url)
        thumbnailImageView.kf.setImage(with: imageURL)
        nameLabel.text = item.name
    }
}
