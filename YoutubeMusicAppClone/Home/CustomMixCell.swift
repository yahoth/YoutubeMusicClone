//
//  CustomMixCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit

class CustomMixCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
    func configure(item: CustomMix) {
        thumbnailImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        artistsLabel.text = item.artists
    }
}
