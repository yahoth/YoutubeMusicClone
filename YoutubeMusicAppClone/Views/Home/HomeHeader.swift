//
//  HomeHeader.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit

class HomeHeader: UICollectionReusableView {
        
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var sectionIndex: Int!

    var vm: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnail.clipsToBounds = true
        thumbnail.contentMode = .scaleAspectFill
        setBorderForView(thumbnail, borderWidth: 1, borderColor: CGColor(gray: 1, alpha: 1), cornerRadius: 25)
        setBorderForView(moreButton, borderWidth: 1, borderColor: CGColor(gray: 0.5, alpha: 0.5), cornerRadius: 12)
    }

    private func setBorderForView(_ view: UIView, borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat) {
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.layer.cornerRadius = cornerRadius
    }

    func configure() {
        switch self.sectionIndex {
        case 0:
            configureBySection(header: "User", title: "다시 듣기", isMoreButtonHidden: false, isThumbnailHidden: false)
        case 1:
            configureBySection(header: "이 노래로 뮤직 스테이션 시작하기", title: "빠른 선곡", isMoreButtonHidden: true, isThumbnailHidden: true)
        case 2:
            configureBySection(header: "뮤직 스테이션 만들기", title: "나만의 뮤직 스테이션", isMoreButtonHidden: true, isThumbnailHidden: true)
        case 3:
            configureBySection(header: nil, title: "맞춤 믹스", isMoreButtonHidden: false, isThumbnailHidden: true)
        default:
            break
        }

        func configureBySection(header: String?, title: String, isMoreButtonHidden: Bool, isThumbnailHidden: Bool) {
            sectionHeaderLabel.text = header
            sectionTitleLabel.text = title
            moreButton.isHidden = isMoreButtonHidden
            thumbnail.isHidden = isThumbnailHidden
        }
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        vm.moreButtonTapped.send(self.sectionIndex)
    }
}

