//
//  QuickSelectionCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit

class QuickSelectionCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
    }
    
    func configure(item: AudioTrack) {
        let url = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: url)
        titleLabel.text = item.title
        artistLabel.text = item.artist
    }
}
