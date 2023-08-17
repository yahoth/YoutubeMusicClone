//
//  MoreContentListViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import Combine

class MoreContentListViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = AnyHashable
    enum Section {
        case main
    }
    var subscriptions = Set<AnyCancellable>()
    var vm: MoreContentListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func bind() {
        vm.$items.receive(on: RunLoop.main)
            .sink { [unowned self] items in
                self.applySnapshot(items: items)
            }.store(in: &subscriptions)

        vm.didSelectItem
            .receive(on: RunLoop.main)
            .sink { [unowned self] item in
                if let audioTrack = item as? AudioTrack {
                    guard let items = self.vm.items as? [AudioTrack] else { return }
                    self.presentMusicPlayer(with: audioTrack, tracks: items)

                } else if let playlistInfo = item as? PlaylistInfo {
                    let sb = UIStoryboard(name: "PlaylistDetail", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "PlaylistDetailViewController") as! PlaylistDetailViewController
                    vc.vm = PlaylistDetailViewModel(playlistInfo: playlistInfo)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [Item]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items)
        datasource.apply(snapshot)
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCell", for: indexPath) as? MoreCell else { return nil }
            
            cell.configure(item: item)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 20
        let interItemSpacing: CGFloat = 15
        let itemWidth = (self.collectionView.bounds.size.width - (2 * padding) - interItemSpacing) / 2
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

    deinit {
        print("MoreContentListViewController deinit")
        subscriptions.forEach({ $0.cancel() })
    }
}

extension MoreContentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        vm.didSelectItem.send(item)
    }
}
