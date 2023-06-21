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
        
        var title: String {
            switch self {
            case .listenAgain: return "Listen Agian"
            case .quickSelection: return "Quick Selection"
            }
        }
    }
    
    let items = ListenAgain.mocks
    let quickSelections = QuickSelection.mocks
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
                let padding: CGFloat = 15
                let interGroupSpacing: CGFloat = 10
                let itemWidth = (self.collectionView.bounds.size.width - (2*padding) - (2*interGroupSpacing)) / 3
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(400))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .flexible(15)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: padding, bottom: 30, trailing: padding)
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
                
            default:
                let padding: CGFloat = 15
                let interGroupSpacing: CGFloat = 10
                let itemWidth = (self.collectionView.bounds.size.width - (2*padding) - (interGroupSpacing))
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
                group.interItemSpacing = .fixed(15)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = interGroupSpacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: padding, bottom: 30, trailing: padding)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
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
