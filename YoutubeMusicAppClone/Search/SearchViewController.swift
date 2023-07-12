//
//  SearchViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/03.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    typealias Item = SearchResponse.TracksItems
    enum Section {
        case main
    }
    
    private var previousView: UIView?

    var vm: SearchViewModel!
    var apiManager: APIManager!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        embedSearchControl()
        setNavigationItem()
        bind()
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
    }
    
    private func addNewViewAndRemovePrevious(_ newView: UIView) {
        previousView?.removeFromSuperview()

        self.view.addSubview(newView)
        previousView = newView
    }
    
    private func configureSearchResultView(items: [SearchResponse.TracksItems]) {
        let myView = SearchResultView()
        
        myView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        myView.searchButtonClicked.send(items)
        
        self.addNewViewAndRemovePrevious(myView)
        let safeArea = view.safeAreaLayoutGuide
        myView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            myView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            myView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func bind() {
        //output
        apiManager.searchResults.receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(items: items)
            }.store(in: &subscriptions)
        
        //input
        apiManager.searchButtonClicked.receive(on: RunLoop.main)
            .sink { items in
                self.configureSearchResultView(items: items)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        apiManager.searchClicked(keyword: keyword)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        apiManager.search(keyword: keyword)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go to SearchResult by 클릭한 검색어에 대해서
        print(datasource.itemIdentifier(for: indexPath))
    }
}
