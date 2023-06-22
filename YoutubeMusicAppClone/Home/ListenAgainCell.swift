//
//  ListenAgainCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit

class ListenAgainCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.cornerRadius = 4
        
    }
    
    func configure(item: ListenAgain) {
        thumbnailImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }
}
