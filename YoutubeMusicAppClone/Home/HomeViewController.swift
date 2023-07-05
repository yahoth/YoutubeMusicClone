//
//  HomeViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = AnyHashable
    enum Section: Int, CaseIterable {
        case listenAgain
        case quickSelection
        case myStation
        case customMix
        case playlistCard
    }
    
    var vm = HomeViewModel(networkConfig: .default)
    
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        bind()
        vm.requestAccessToken()
        vm.fetch()
        updateNavigationItem()
        setNavigationBarlogo()
    }
    
    private func setNavigationBarlogo() {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: -12, y: 0, width: 80, height: 44)
        logoImageView.contentMode = .scaleAspectFit
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        logoView.clipsToBounds = false
        logoView.addSubview(logoImageView)
        let logoItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoItem
    }
    
    private func updateNavigationItem() {
        let connectConfig = CustomBarItemConfiguration(image: UIImage(named: "connect"), handler: {print("connect") })
        let connectItem = UIBarButtonItem.generate(config: connectConfig, width: 30)
        
        let searchConfig = CustomBarItemConfiguration(image: UIImage(systemName: "magnifyingglass")) {
            print("search")
            let sb = UIStoryboard(name: "Search", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            vc.vm = SearchViewModel(accessToken: self.vm.accessToken, networkConfig: .default)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let searchItem = UIBarButtonItem.generate(config: searchConfig, width: 30, height: 30)
        
        let nameConfig = CustomBarItemConfiguration(title: "태형", handler: {print("태형")})
        let nameItem = UIBarButtonItem.generate(config: nameConfig, width: 28, height: 28)
        
        nameItem.customView?.backgroundColor = .systemTeal
        nameItem.customView?.layer.cornerRadius = 14
        navigationItem.rightBarButtonItems = [nameItem, searchItem, connectItem]
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            let cell = self.configureCell(section: section, item: item, collectionView: collectionView, indexPath: indexPath)
            
            return cell
        })
        
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeHeader else { return nil }
            
            let sectionIndex = Section(rawValue: indexPath.section)!.rawValue
            header.configure(sectionIndex: sectionIndex)
            return header
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([], toSection: .listenAgain)
        snapshot.appendItems([], toSection: .quickSelection)
        snapshot.appendItems([], toSection: .myStation)
        snapshot.appendItems([], toSection: .customMix)
        snapshot.appendItems([], toSection: .playlistCard)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }
    
    private func applySnapshot(to section: Section, items: [AnyHashable]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func bind() {
        vm.agains
            .receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(to: .listenAgain, items: items)
            }.store(in: &subscriptions)
        vm.quickSelections
            .receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(to: .quickSelection, items: items)
            }.store(in: &subscriptions)
        vm.myStation
            .receive(on: RunLoop.main)
            .sink { item in
                self.applySnapshot(to: .myStation, items: [item])
            }.store(in: &subscriptions)
        
        vm.customMixes
            .receive(on: RunLoop.main)
            .sink { items in
                self.applySnapshot(to: .customMix, items: items)
            }.store(in: &subscriptions)
        
        vm.playlistCard
            .receive(on: RunLoop.main)
            .sink { item in
                self.applySnapshot(to: .playlistCard, items: [item])
            }.store(in: &subscriptions)
    }
    
    private func configureCell(section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        
        switch section {
        case .listenAgain:
            if let item = item as? ListenAgain {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListenAgainCell", for: indexPath) as! ListenAgainCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        case .quickSelection:
            if let item = item as? QuickSelection {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickSelectionCell", for: indexPath) as! QuickSelectionCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        case .myStation:
            if item is MyStation {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStationCell", for: indexPath) as! MyStationCell
                return cell
            } else {
                return nil
            }
        case .customMix:
            if let item = item as? CustomMix {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMixCell", for: indexPath) as! CustomMixCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
            
        case .playlistCard:
            if let item = item as? PlaylistCard {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCardCell", for: indexPath) as! PlaylistCardCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        }
    }
    
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let padding: CGFloat = 20
                let interGroupSpacing: CGFloat = 16
                let itemWidth = (self.collectionView.bounds.size.width - (2 * padding) - (2 * interGroupSpacing)) / 3
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(380))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 20, trailing: padding)
                section.orthogonalScrollingBehavior = .continuous
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
                
            case 1:
                let paddig: CGFloat = 20
                let interGroupSpacing: CGFloat = 16
                let interItemSpacing: CGFloat = 16
                let itemWidth: CGFloat = self.collectionView.bounds.size.width - (paddig * 2)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
                group.interItemSpacing = .fixed(interItemSpacing)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: paddig, leading: paddig, bottom: 50, trailing: paddig)
                section.interGroupSpacing = interGroupSpacing
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            case 2:
                let padding: CGFloat = 20
                let sectionWidth = self.collectionView.bounds.size.width - (2 * padding)
                let sectionHeight = sectionWidth / 2
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth), heightDimension: .absolute(sectionHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth), heightDimension: .absolute(sectionHeight))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 50, trailing: padding)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            case 3:
                let padding: CGFloat = 20
                let interItemSpacing: CGFloat = 16
                let groupWidth = self.collectionView.bounds.size.width - padding * 2
                let itemWidth = (groupWidth - interItemSpacing) / 2
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .estimated(itemWidth + 100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(interItemSpacing)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 50, trailing: padding)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
                
            case 4:
                let padding: CGFloat = 20
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(520))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                return section
                
            default: return nil
            }
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource.itemIdentifier(for: indexPath)
    }
}
