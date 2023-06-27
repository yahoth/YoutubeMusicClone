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
        thumbnail.layer.cornerRadius = 25
        moreButton.layer.borderWidth = 1
        moreButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        moreButton.layer.cornerRadius = 12
    }
    
    func configure(sectionIndex: Int) {
        switch sectionIndex {
        case 0:
            nameLabel.text = "김태형"
            moreButton.isHidden = false
            thumbnail.isHidden = false
            sectionTitleLabel.text = "Listen Again"

        case 1:
            nameLabel.text = "이 노래로 뮤직 스테이션 시작하기"
            moreButton.isHidden = true
            thumbnail.isHidden = true
            sectionTitleLabel.text = "Quick Selection"

        case 2:
            nameLabel.text = "뮤직 스테이션 만들기"
            moreButton.isHidden = true
            thumbnail.isHidden = true
            sectionTitleLabel.text = "My Music Station"
            
        case 3:
            nameLabel.text = ""
            moreButton.isHidden = false
            thumbnail.isHidden = true
            sectionTitleLabel.text = "Custom Mix"

        default:
            break
        }
    }
}

