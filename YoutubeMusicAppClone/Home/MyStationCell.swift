//
//  MyStationCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/22.
//

import UIKit

class MyStationCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure() {
        imageView.image = UIImage(named: "mystation")
    }
}
