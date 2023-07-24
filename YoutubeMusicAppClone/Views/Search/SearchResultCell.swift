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
    
    override init(frame: CGRect) {
        thumbnailImageView = UIImageView()
        titleLabel = UILabel()
        subtitleLabel = UILabel()

        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 이미지뷰 설정
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

    func configure(item: AudioTrack) {
        let imageUrl = URL(string: item.imageName)
        thumbnailImageView.kf.setImage(with: imageUrl)
        titleLabel.text = item.title
        subtitleLabel.text = "\(item.artist) \(durationTimeFormatter(item.duration))"
    }

    private func durationTimeFormatter(_ inputDurationTime: Int?) -> String {
        //제공받는 타입은 Int, 예시: 184444 -> 3:05
        //4번째수에서 올림하여 185로 만든 뒤 3:05로 변환
        guard let inputDurationTime else { return "" }
        let digit: Double = pow(10, 3)
        let durationTime = Int(ceil(Double(inputDurationTime) / digit))
        let minutes = durationTime / 60
        let seconds = durationTime % 60

        return String(format: "%2d:%02d", minutes, seconds)
    }
}
