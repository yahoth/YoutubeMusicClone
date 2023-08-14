//
//  PlaylistCardCell.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/27.
//

import UIKit
import Combine

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

    var vm: CardCellViewModel!
    var subscriptions = Set<AnyCancellable>()

    var datasource: UICollectionViewDiffableDataSource<Section, Item>!

    typealias Item = AudioTrack
    enum Section {
        case main
    }

    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        setupUI()
    }

    func bind() {
        vm.didSelectItem
            .receive(on: RunLoop.main)
            .sink { item in
                self.vm.viewController.presentMusicPlayer(with: item, tracks: self.vm.tracks)
            }.store(in: &subscriptions)
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        guard let first = self.vm.tracks.first else { return }
        vm.didSelectItem.send(first)
    }

    func configureCellAndCollectionView() {
        configure()
        configureCollectionView()
    }

    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardTrackListCell", for: indexPath) as? CardTrackListCell else { return nil }
            cell.configure(item: item)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(self.vm.tracks.prefix(3)))
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
    
    private func configure() {
        thumbnailImageView.kf.setImage(with: URL(string: vm.playlist.imageName))
        titleLabel.text = vm.playlist.title
        recommenderLabel.text = "YouTube Music"
        listCountLabel.text = "노래 \(vm.tracks.count)곡"
        descriptionLabel.text = vm.playlist.description
    }
}

extension CardCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        vm.didSelectItem.send(item)
    }
}
