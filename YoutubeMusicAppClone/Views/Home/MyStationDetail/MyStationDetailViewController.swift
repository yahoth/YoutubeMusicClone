//
//  MyStationDetailViewController.swift
//  YoutubeMusicAppClone
//
//  Created by TAEHYOUNG KIM on 2023/07/06.
//

import UIKit
import Combine

class MyStationDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    typealias Item = RelatedArtistsResponse.Artists
    enum Section {
        case main
    }
    var vm: MyStationDetailViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNextButton()
        configureCollectionView()
        vm.fetch()
        bind()
        setNavigationItem()
    }

    private func configureNextButton() {
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextButton.titleEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        nextButton.imageEdgeInsets = .init(top: 20, left: 8, bottom: 20, right: 0)
        nextButton.contentEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        nextButton.setTitle("다음", for: .normal)
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.semanticContentAttribute = .forceRightToLeft
        nextButton.layer.cornerRadius = 30
    }

    private func setNavigationItem() {
        let titleConfig = CustomBarItemConfiguration(title: "아티스트 선택", handler: {print("아티스트 선택")})
        let titleItem = UIBarButtonItem.generate(config: titleConfig, fontSize: 20)
        let dismissConfig = CustomBarItemConfiguration(image: UIImage(systemName: "xmark"), handler: {self.dismiss(animated: true)})
        let dismissItem = UIBarButtonItem.generate(config: dismissConfig)
        navigationItem.leftBarButtonItems = [titleItem]
        navigationItem.rightBarButtonItems = [dismissItem]
    }
    
    private func bind() {
        vm.artists
            .receive(on: RunLoop.main)
            .sink { artissts in
                self.applySnapshot(to: .main, items: artissts)
            }.store(in: &subscriptions)
    }

    private func applySnapshot(to section: Section, items: [RelatedArtistsResponse.Artists]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStationDetailCell", for: indexPath) as? MyStationDetailCell else { return nil }
            cell.configure(item: item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 20
        let interItemSize: CGFloat = 10
        let itemWidth = (collectionView.bounds.size.width - (padding * 2) - (interItemSize * 2)) / 3
        let itemHeight = itemWidth + 40
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        group.interItemSpacing = .fixed(interItemSize)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
