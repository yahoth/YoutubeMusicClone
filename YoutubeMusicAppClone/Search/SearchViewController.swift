//
//  SearchViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    typealias Item = SearchResult
    enum Section {
        case main
    }
    
    var vm: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        embedSearchControl()
        setNavigationItem()
        collectionView.collectionViewLayout = layout()
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as? SearchCell else {return nil}
            
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
        navigationItem.titleView = searchController
        searchController.delegate = self

        
//        let searchController = UISearchController(searchResultsController: nil)
//
//        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
        
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

//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let keyword = searchController.searchBar.text
//        print("search: \(keyword)")
//    }
//}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        vm.search(keyword: keyword)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText:\(searchText)")
        print("searchbarText:\(searchBar.text)")
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
