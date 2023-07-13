//
//  SearchResultCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit
import Kingfisher

class SearchResultCell: UICollectionViewCell {
    
    private let thumbnailImageView: UIImageView
    private let titleLabel: UILabel
    private let subtitleLabel: UILabel
//    private let button: UIButton
    
    override init(frame: CGRect) {
        thumbnailImageView = UIImageView()
        titleLabel = UILabel()
        subtitleLabel = UILabel()
//        button = UIButton(type: .system)
        
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 이미지뷰 설정
//        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        // 타이틀 라벨 설정
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        // 서브타이틀 라벨 설정
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        
        // 버튼 설정
//        button.setTitle("Button", for: .normal)
//        button.setTitleColor(.blue, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        // 가로 스택뷰 설정
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        verticalStackView.axis = .vertical
        
        let horizontalStackView = UIStackView(arrangedSubviews: [thumbnailImageView, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .leading
        horizontalStackView.spacing = 8
        
       
        // 셀에 가로 스택뷰를 추가합니다.
        contentView.addSubview(horizontalStackView)
        
        // 가로 스택뷰를 셀과의 제약조건으로 설정합니다.
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    func configure(item: SearchResponse.TracksItems) {
                let imageUrl = URL(string: item.album.images[0].url)
                thumbnailImageView.kf.setImage(with: imageUrl)
        titleLabel.text = item.name
        subtitleLabel.text = "\(item.album.artists[0].name) \(item.duration)"
    }
}
