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
        thumbnailImageView.layer.cornerRadius = 4
        firstAlbumImageView.layer.cornerRadius = 4
        secondAlbumImageView.layer.cornerRadius = 4
        thirdAlbumImageView.layer.cornerRadius = 4

        playButton.layer.cornerRadius = 30
        shuffleButton.layer.cornerRadius = 30
        shuffleButton.layer.borderWidth = 1
        shuffleButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        addPlaylistButton.layer.cornerRadius = 30
        addPlaylistButton.layer.borderWidth = 1
        addPlaylistButton.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
    }
    
    func configure(item: PlaylistCard) {
        
        thumbnailImageView.kf.setImage(with: URL(string: item.imageName))
        titleLabel.text = item.title
        recommenderLabel.text = "YouTube Music"
        listCountLabel.text = "노래 \(item.tracks.count)곡"
        descriptionLabel.text = item.description
        
        firstAlbumImageView.kf.setImage(with: URL(string: item.tracks[0].imageName))
        firstAlbumTitleLabel.text = item.tracks[0].title
        firstSubTitleLabel.text = item.tracks[0].subTitle
        
        secondAlbumImageView.kf.setImage(with: URL(string: item.tracks[1].imageName))
        secondAlbumTitleLabel.text = item.tracks[1].title
        secondSubTitleLabel.text = item.tracks[1].subTitle
        
        thirdAlbumImageView.kf.setImage(with: URL(string: item.tracks[2].imageName))
        thirdAlbumTitleLabel.text = item.tracks[2].title
        thirdSubTitleLabel.text = item.tracks[2].subTitle

    }
}
