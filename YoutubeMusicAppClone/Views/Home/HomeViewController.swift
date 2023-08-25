//
//  HomeViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import SwiftUI
import Combine

enum HomeViewSection: Int, CaseIterable, Hashable {
    case listenAgain
    case quickPicks
    case yourMusicTuner
    case mixedForYou
    case playlistCard
}

class HomeViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = AnyHashable
    typealias Section = HomeViewSection

    var vm = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setNavigationItem()
        setNavigationBarlogo()
        vm.fetch()
        bind()
        addRefreshControl()
    }

    private func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refreshView() {
        vm.refresh()
        self.refreshControl.endRefreshing()
    }

    private func setNavigationBarlogo() {
        let logoImage = UIImage(named: "logo")
        let logoConfig = CustomBarItemConfiguration(image: logoImage, handler: {
            print("Logo")
        })
        let logoItem = UIBarButtonItem.generate(config: logoConfig, width: 80)
        navigationItem.leftBarButtonItem = logoItem
    }
    
    private func setNavigationItem() {
        let connectConfig = CustomBarItemConfiguration(image: UIImage(named: "connect"), handler: {print("connect") })
        let connectItem = UIBarButtonItem.generate(config: connectConfig, width: 30)
        
        let searchConfig = CustomBarItemConfiguration(image: UIImage(systemName: "magnifyingglass")) {
            print("search")
            let vm = SearchViewModel()
            let searchView = SearchView(vm: vm) { [weak self] in
                self?.dismiss(animated: true)
            }
            let vc = UIHostingController(rootView: searchView)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
        let searchItem = UIBarButtonItem.generate(config: searchConfig, width: 30, height: 30)
        
        let nameConfig = CustomBarItemConfiguration(image: UIImage(named: "profileImage"), handler: { print("profile") })
        let nameItem = UIBarButtonItem.generate(config: nameConfig, width: 28, height: 28, contentMode: .scaleAspectFill)
        nameItem.customView?.clipsToBounds = true
        nameItem.customView?.layer.cornerRadius = 14
        nameItem.customView?.layer.borderWidth = 1
        nameItem.customView?.layer.borderColor = CGColor(gray: 1, alpha: 1)

        navigationItem.rightBarButtonItems = [nameItem, searchItem, connectItem]
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            let cell = self?.configureCell(section: section, item: item, collectionView: collectionView, indexPath: indexPath)
            
            return cell
        })
        
        datasource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeHeader else { return nil }
            header.vm = self?.vm
            header.sectionIndex = section.rawValue
            header.configure()
            
            return header
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([], toSection: .listenAgain)
        snapshot.appendItems([], toSection: .quickPicks)
        snapshot.appendItems([YourMusicTuner.mock], toSection: .yourMusicTuner)
        snapshot.appendItems([], toSection: .mixedForYou)
        snapshot.appendItems([], toSection: .playlistCard)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }

    private func configureCell(section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        
        switch section {
        case .listenAgain:
            if let item = item as? AudioTrack {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListenAgainCell", for: indexPath) as! ListenAgainCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        case .quickPicks:
            if let item = item as? AudioTrack {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickPicksCell", for: indexPath) as! QuickPicksCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
        case .yourMusicTuner:
            if item is YourMusicTuner {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourMusicTunerCell", for: indexPath) as! YourMusicTunerCell
                return cell
            } else {
                return nil
            }
        case .mixedForYou:
            if let item = item as? PlaylistInfo {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MixedForYouCell", for: indexPath) as! MixedForYouCell
                cell.configure(item: item)
                return cell
            } else {
                return nil
            }
            
        case .playlistCard:
            if let item = item as? PlaylistCard {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
                cell.vm = CardCellViewModel(viewController: self, playlist: item)
                cell.configureCellAndCollectionView()
                cell.bind()
                return cell
            } else {
                return nil
            }
        }
    }

    private func applySnapshot(to section: Section, items: [AnyHashable]) {
        var snapshot = datasource.snapshot()
        // 해당 섹션의 현재 아이템을 삭제
        let currentItems = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(currentItems)
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func bind() {
        // Output
        vm.listenAgain
            .receive(on: RunLoop.main)
            .sink { [unowned self] items in
                self.applySnapshot(to: .listenAgain, items: Array(items.prefix(20)))
            }.store(in: &subscriptions)
        
        vm.quickPicks
            .receive(on: RunLoop.main)
            .sink { [unowned self] items in
                self.applySnapshot(to: .quickPicks, items: Array(items.prefix(20)))
            }.store(in: &subscriptions)

        vm.mixedForYou
            .receive(on: RunLoop.main)
            .sink { [unowned self] items in
                self.applySnapshot(to: .mixedForYou, items: Array(items.prefix(20)))
            }.store(in: &subscriptions)
        
        vm.playlistCard
            .receive(on: RunLoop.main)
            .sink { [unowned self] item in
                self.applySnapshot(to: .playlistCard, items: [item])
            }.store(in: &subscriptions)

        // Input Action
        vm.moreButtonTapped
            .receive(on: RunLoop.main)
            .sink { [unowned self] sectionIndex in
                let sb = UIStoryboard(name: "MoreContentList", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MoreContentListViewController") as! MoreContentListViewController
                vc.vm = MoreContentListViewModel(with: sectionIndex == 0 ? self.vm.listenAgain.value : self.vm.mixedForYou.value)
                self.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &subscriptions)

        vm.didSelectItem
            .receive(on: RunLoop.main)
            .sink { [unowned self] (section, item, tracks) in
                switch section {
                case .listenAgain, .quickPicks:
                    self.presentMusicPlayer(with: item, tracks: tracks)
                case .yourMusicTuner:
                    let sb = UIStoryboard(name: "YourMusicTunerDetail", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "YourMusicTunerDetailViewController") as! YourMusicTunerDetailViewController
                    let navController = UINavigationController(rootViewController: vc)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true)

                case .mixedForYou, .playlistCard:
                    self.pushPlaylistDetailView(with: item, section: section)
                }
            }.store(in: &subscriptions)
    }

    private func pushPlaylistDetailView(with item: Any, section: Section) {
        let sb = UIStoryboard(name: "PlaylistDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PlaylistDetailViewController") as! PlaylistDetailViewController
        if section == .mixedForYou {
            guard let item = item as? PlaylistInfo else { return }
            vc.vm = PlaylistDetailViewModel(playlistInfo: item)
        } else {
            guard let item = item as? PlaylistCard else { return }
            let info = PlaylistInfo(id: item.id, description: item.description, imageName: item.imageName, title: item.title)
            vc.vm = PlaylistDetailViewModel(playlistInfo: info, tracks: item.tracks)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let padding: CGFloat = 20
            let interGroupSpacing: CGFloat = 16
            let interItemSpacing: CGFloat = 16
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            switch HomeViewSection(rawValue: sectionIndex) {

            case .listenAgain:
                let itemWidth = (self.collectionView.bounds.size.width - (2 * padding) - (2 * interGroupSpacing)) / 3
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(380))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [header]
                
                return section
                
            case .quickPicks:
                let itemWidth: CGFloat = self.collectionView.bounds.size.width - (padding * 2)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
                group.interItemSpacing = .fixed(interItemSpacing)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 50, trailing: padding)
                section.interGroupSpacing = interGroupSpacing
                section.boundarySupplementaryItems = [header]
                return section

            case .yourMusicTuner:
                let sectionWidth = self.collectionView.bounds.size.width - (2 * padding)
                let sectionHeight = sectionWidth / 2
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth), heightDimension: .absolute(sectionHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth), heightDimension: .absolute(sectionHeight))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 50, trailing: padding)
                section.boundarySupplementaryItems = [header]
                return section

            case .mixedForYou:
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
                section.boundarySupplementaryItems = [header]
                return section
                
            case .playlistCard:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(520))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
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
        guard let section = Section(rawValue: indexPath.section),
              let item = datasource.itemIdentifier(for: indexPath) else { return }
        
        switch section {
        case .listenAgain:
            vm.didSelectItem.send((section: .listenAgain, item: item, tracks: vm.listenAgain.value))
            
        case .quickPicks:
            vm.didSelectItem.send((section: .quickPicks, item: item, tracks: vm.quickPicks.value))

        case .yourMusicTuner:
            vm.didSelectItem.send((section: .yourMusicTuner, item: item, tracks: []))

        case .mixedForYou:
            vm.didSelectItem.send((section: .mixedForYou, item: item, tracks: []))
            
        case .playlistCard:
            vm.didSelectItem.send((section: .playlistCard, item: item, tracks: []))
        }
    }
}
