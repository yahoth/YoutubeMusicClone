//
//  PlaylistCardCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit

class PlaylistCardCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recommenderLabel: UILabel!
    @IBOutlet weak var listCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstAlbumImageView: UIImageView!
    @IBOutlet weak var firstAlbumTitleLabel: UILabel!
    @IBOutlet weak var firstSubTitleLabel: UILabel!
    
    @IBOutlet weak var secondAlbumImageView: UIImageView!
    @IBOutlet weak var secondAlbumTitleLabel: UILabel!
    @IBOutlet weak var secondSubTitleLabel: UILabel!
    
    @IBOutlet weak var thirdAlbumImageView: UIImageView!
    @IBOutlet weak var thirdAlbumTitleLabel: UILabel!
    @IBOutlet weak var thirdSubTitleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var addPlaylistButton: UIButton!
    
    
    override func awakeFromNib() {

        self.layer.cornerRadius = 20
     setupUI()
    }
    
    private func setupUI() {
        
        thumbnailImageView.layer.cornerRadius = 5
        firstAlbumImageView.layer.cornerRadius = 5
        secondAlbumImageView.layer.cornerRadius = 5
        thirdAlbumImageView.layer.cornerRadius = 5

        playButton.layer.cornerRadius = 30
        shuffleButton.layer.cornerRadius = 30
        shuffleButton.layer.borderWidth = 1
        shuffleButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        addPlaylistButton.layer.cornerRadius = 30
        addPlaylistButton.layer.borderWidth = 1
        addPlaylistButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
    }
    
    func configure(item: RecommendList) {
        thumbnailImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        recommenderLabel.text = item.recommender
        listCountLabel.text = "노래 \(item.list.count)곡"
        descriptionLabel.text = item.description
        
        firstAlbumImageView.image = UIImage(named: item.list[0].imageName)
        firstAlbumTitleLabel.text = item.list[0].title
        firstSubTitleLabel.text = item.list[0].subTitle
        
        secondAlbumImageView.image = UIImage(named: item.list[1].imageName)
        secondAlbumTitleLabel.text = item.list[1].title
        secondSubTitleLabel.text = item.list[1].subTitle
        
        thirdAlbumImageView.image = UIImage(named: item.list[2].imageName)
        thirdAlbumTitleLabel.text = item.list[2].title
        thirdSubTitleLabel.text = item.list[2].subTitle

    }
}
