//
//  DetailViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import Combine

class DetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = AnyHashable
    enum Section {
        case main
    }
    var subscriptions = Set<AnyCancellable>()
    var vm: HomeDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        vm.$items.receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(items: items)
                print("item11: \(items)")
            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [Item]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items)
        datasource.apply(snapshot)
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell else { return nil }
            
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
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
