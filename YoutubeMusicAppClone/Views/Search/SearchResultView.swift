//
//  SearchResultView.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/05.
//

import UIKit
import Combine

class SearchResultView: UIView {
    
    private var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = SearchResponse.TracksItems
    enum Section {
        case main
    }
    
    var subscriptions = Set<AnyCancellable>()
    var searchButtonClicked: PassthroughSubject<[SearchResponse.TracksItems], Never>
    
    override init(frame: CGRect) {
        searchButtonClicked = PassthroughSubject()
        super.init(frame: frame)
        configureCollectionView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        searchButtonClicked.receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(items: items)
            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [SearchResponse.TracksItems]) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
    }
    
    
    private func configureCollectionView() {
        let collectionViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout())
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {return nil}
            cell.configure(item: item)
            return cell
        })
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 20
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }}

extension SearchResultView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(datasource.itemIdentifier(for: indexPath))
    }
}
