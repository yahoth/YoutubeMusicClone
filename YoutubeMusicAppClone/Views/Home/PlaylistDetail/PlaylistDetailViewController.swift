//
//  PlaylistDetailViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/17.
//

import UIKit
import Combine

class PlaylistDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var datasource: UICollectionViewDiffableDataSource<Section, Item>!

    typealias Item = AnyHashable

    enum Section: Int, CaseIterable {
        case info
        case track
    }

    var subscriptions = Set<AnyCancellable>()

    var vm: PlaylistDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }

    private func bind() {
        vm.$playlistInfo.receive(on: RunLoop.main)
            .sink { info in
                self.applySnapshot(to: .info, items: [info])
            }.store(in: &subscriptions)

        vm.playlistTrack
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { track in
                self.applySnapshot(to: .track, items: track)
                print(track)
            }.store(in: &subscriptions)
    }

    private func applySnapshot(to section: Section, items: [AnyHashable]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }

    private func configureCell(section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        switch section {
        case .info:
            if let item = item as? Playlist {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistInfoCell", for: indexPath) as! PlaylistInfoCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        case .track:
            if let item = item as? AudioTrack {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistTrackCell", for: indexPath) as! PlaylistTrackCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        }
    }

    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            let cell = self.configureCell(section: section, item: item, collectionView: collectionView, indexPath: indexPath)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([], toSection: .info)
        snapshot.appendItems([], toSection: .track)
        datasource.apply(snapshot)

        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            switch sectionIndex {

            case 0:
                let padding: CGFloat = 40
                let itemWidth = self.collectionView.bounds.size.width - (2 * padding)
                let itemHeight = self.collectionView.bounds.size.height / 2
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(itemHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(itemHeight))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
                return section

            case 1:
                let padding: CGFloat = 20
                let interGroupSpacing: CGFloat = 16
                let itemWidth = self.collectionView.bounds.size.width - (2 * padding)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                return section

            default:
                return nil
            }
        }
        return layout
    }
}

extension PlaylistDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource.itemIdentifier(for: indexPath)
        let sb = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.vm = MusicPlayerViewModel()
        guard let item = item as? AudioTrack else {return}
        vc.vm.currentPlayingTracks.send(self.vm.playlistTrack.value)
        vc.vm.item.send(item)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
