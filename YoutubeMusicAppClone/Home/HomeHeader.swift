//
//  HomeHeader.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit

class HomeHeader: UICollectionReusableView {
        
    @IBOutlet weak var thumbnail: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnail.layer.masksToBounds = true
        thumbnail.layer.cornerRadius = 20
    }
    
    func configure(section: String) {
        switch section {
        case "Listen Again":
            nameLabel.text = "김태형"
        case "Quick Selection":
            nameLabel.text = "이 노래로 뮤직 스테이션 시작하기"
            moreButton.isHidden = true
            thumbnail.isHidden = true
        default:
            break
        }
        sectionTitleLabel.text = section
    }
}

