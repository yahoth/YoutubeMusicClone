//
//  MyStationCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import UIKit

class MyStationCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 4
    }
    
    func configure() {
        imageView.image = UIImage(named: "mystation")
    }
}
