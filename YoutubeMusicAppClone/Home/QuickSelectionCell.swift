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
        
        thumbnailImageView.layer.cornerRadius = 5
    }
    
    func configure(item: QuickSelection) {
        thumbnailImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        artistLabel.text = item.artist
    }
}
