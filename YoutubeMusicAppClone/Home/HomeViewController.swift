//
//  HomeViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/06/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
/// Data: Snapshot, Presentation: Diffable, Layout: Compositional
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = AnyHashable
    enum Section: Int, CaseIterable {
        case listenAgain
        case quickSelection
        case myStation
        
        var title: String {
            switch self {
            case .listenAgain: return "Listen Agian"
            case .quickSelection: return "Quick Selection"
            case .myStation: return "My Music Station"
            }
        }
    }
    
    let items = ListenAgain.mocks
    let quickSelections = QuickSelection.mocks
    let myStation = MyStation.mock
    
    var didSelect = PassthroughSubject<Item, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            let cell = self.configureCell(section: section, item: item, collectionView: collectionView, indexPath: indexPath)
            
            return cell
        })
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeHeader else { return nil }
            let allSection = Section.allCases
            let section = allSection[indexPath.section]
            header.configure(section: section.title)
            return header
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .listenAgain)
        snapshot.appendItems(quickSelections, toSection: .quickSelection)
        snapshot.appendItems([myStation], toSection: .myStation)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
        
        bind()
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
            if let item = item as? MyStation {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStationCell", for: indexPath) as! MyStationCell
                return cell
            } else {
                return nil
            }
        }
    }
    
    private func bind() {
        didSelect
            .receive(on: RunLoop.main)
            .sink { item in
                let storyboad = UIStoryboard(name: "Detail", bundle: nil)
                let vc = storyboad.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &subscriptions)
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
                group.interItemSpacing = .flexible(15)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 50, trailing: padding)
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
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
            default: return nil
            }
        }
        layout.configuration.interSectionSpacing = 100
        //        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        didSelect.send(item)
    }
}
