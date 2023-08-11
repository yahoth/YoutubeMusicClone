//
//  PlaylistCardCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recommenderLabel: UILabel!
    @IBOutlet weak var listCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var addPlaylistButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!

    var datasource: UICollectionViewDiffableDataSource<Section, Item>!

    typealias Item = AudioTrack
    enum Section {
        case main
    }

    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        setupUI()
    }

    func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardTrackListCell", for: indexPath) as? CardTrackListCell else { return nil }
            cell.configure(item: item)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupUI() {
        thumbnailImageView.layer.cornerRadius = 4

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
    }
}

extension CardCell: UICollectionViewDelegate {

}
