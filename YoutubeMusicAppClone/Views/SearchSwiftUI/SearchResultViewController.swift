//
//  SearchResultViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit
import Combine

class SearchResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    typealias Item = SearchResponse.TracksItems
    enum Section {
        case main
    }
    var subscriptions = Set<AnyCancellable>()
    var vm: SearchResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        embedSearchControl()
        setNavigationItem()
        collectionView.collectionViewLayout = layout()
    }
    
    private func bind() {
//        vm.searchResults.receive(on: RunLoop.main)
//            .sink { items in
//                print(items)
//                self.applySnapshot(items: items)
//            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [SearchResponse.TracksItems]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
    }
    
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {return nil}
            
            cell.configure(item: item)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
    }
    
    private func embedSearchControl() {
        let searchController = UISearchBar()
        searchController.sizeToFit()
        searchController.placeholder = "노래, 앨범, 아티스트 검색"
        searchController.text = vm.keyword
        navigationItem.titleView = searchController
//        searchController.delegate = self
    }
    
    private func setNavigationItem() {
        let voiceSearchConfig = CustomBarItemConfiguration(
            image: UIImage(systemName: "mic.fill"),
            handler: {print("voice search")}
        )
        let voiceItem = UIBarButtonItem.generate(config: voiceSearchConfig)
        navigationItem.rightBarButtonItems = [voiceItem]
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let padding: CGFloat = 20
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(380))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
