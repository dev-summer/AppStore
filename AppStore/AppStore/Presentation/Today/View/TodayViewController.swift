//
//  TodayViewController.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import UIKit

final class TodayViewController: UIViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<TodaySection, TodayItem>
    typealias DataSource = UICollectionViewDiffableDataSource<TodaySection, TodayItem>
    typealias LargeCellRegistration = UICollectionView.CellRegistration<TodayLargeCell, TodayItem>
    typealias ListCellRegistration = UICollectionView.CellRegistration<TodayListCell, TodayItem>
    
    private enum Namespace {
        static let confirm: String = "확인"
        static let layoutHeader: String = "layout header"
        static let layoutHeaderTitle: String = "Today"
        static let sectionHeaderTitle: String = "캘린더 앱"
        static let sectionHeaderDescription: String = "스케줄 관리를 도와주는"
    }
    
    private let viewModel: TodayViewModel = TodayViewModel()
    private var dataSource: DataSource?
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureConstraints()
        configureCollectionView()
        configureNavigationBar()
        bind()
        viewModel.fetchApps()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDatasource()
        registerSupplementaryViews()
        configureSupplementaryViews()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            let section = TodaySection(rawValue: sectionIndex)
            
            switch section {
            case .large:
                return self?.createLargeCellSection()
            case .list:
                return self?.createListCellSection(environment: environment)
            default:
                return nil
            }
        }
        
        let configuration = createCollectionViewConfiguration()
        layout.configuration = configuration
        
        return layout
    }
    
    private func createLargeCellSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.identifier)
        ]
        
        return section
    }
    
    private func createListCellSection(
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        let header = createSectionHeaderItem()
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)
        section.boundarySupplementaryItems = [header]
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.identifier)
        ]
        
        return section
    }
    
    private func createCollectionViewConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let header = createLayoutHeaderItem()
        configuration.interSectionSpacing = 16
        configuration.boundarySupplementaryItems = [header]
        
        return configuration
    }
    
    private func createLayoutHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Namespace.layoutHeader,
            alignment: .topLeading
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16, bottom: .zero, trailing: 16)
        
        return header
    }
    
    private func createSectionHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 32, bottom: .zero, trailing: 32)
        
        return header
    }
    
    private func registerSupplementaryViews() {
        collectionView.register(
            LayoutHeaderView.self,
            forSupplementaryViewOfKind: Namespace.layoutHeader,
            withReuseIdentifier: LayoutHeaderView.identifier
        )
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        collectionView.collectionViewLayout.register(
            SectionBackgroundView.self,
            forDecorationViewOfKind: SectionBackgroundView.identifier
        )
    }
    
    private func configureSupplementaryViews() {
        dataSource?.supplementaryViewProvider = { [weak self] _, kind, indexPath in
            if kind == Namespace.layoutHeader {
                return self?.createLayoutHeaderView(indexPath)
            } else {
                let section = TodaySection(rawValue: indexPath.section)
                return section == .list ? self?.createSectionHeaderView(indexPath) : nil
            }
        }
    }
    
    private func createLayoutHeaderView(_ indexPath: IndexPath) -> LayoutHeaderView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: Namespace.layoutHeader,
            withReuseIdentifier: LayoutHeaderView.identifier,
            for: indexPath
        ) as? LayoutHeaderView else { return nil }
        
        header.showDate()
        header.setTitle(with: Namespace.layoutHeaderTitle)
        
        return header
    }
    
    private func createSectionHeaderView(_ indexPath: IndexPath) -> SectionHeaderView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as? SectionHeaderView else { return nil }
        
        header.setTextFor(
            description: Namespace.sectionHeaderDescription,
            title: Namespace.sectionHeaderTitle
        )
        
        return header
    }
    
    private func configureDatasource() {
        let largeCellRegistration = LargeCellRegistration { cell, _, item in
            cell.bind(with: item)
        }
        let listCellRegistration = ListCellRegistration { cell, _, item in
            cell.bind(with: item)
        }
        
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let section = TodaySection(rawValue: indexPath.section)
                
                switch section {
                case .large:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: largeCellRegistration,
                        for: indexPath,
                        item: item
                    )
                case .list:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: listCellRegistration,
                        for: indexPath,
                        item: item
                    )
                default:
                    return nil
                }
            })
    }
    
    private func bind() {
        viewModel.appsDelivered = { [weak self] apps in
            var snapshot = Snapshot()
            snapshot.appendSections(TodaySection.allCases)
            snapshot.appendItems(apps[.large] ?? [], toSection: .large)
            snapshot.appendItems(apps[.list] ?? [], toSection: .list)
            self?.dataSource?.apply(snapshot, animatingDifferences: false)
        }
        viewModel.largeSectionTapped = { [weak self] appID in
            self?.showAppDetail(with: appID)
        }
        viewModel.listSectionTapped = { [weak self] keyword in
            self?.showAppListWith(
                keyword: keyword,
                title: Namespace.sectionHeaderTitle,
                description: Namespace.sectionHeaderDescription
            )
        }
        viewModel.errorDelivered = { [weak self] message in
            self?.showErrorAlert(with: message)
        }
    }
    
    private func showAppDetail(with appID: Int) {
        let detailViewController = DetailViewController(appID: appID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func showAppListWith(keyword: String, title: String, description: String) {
        let appListViewController = AppListViewController(keyword: keyword, title: title, description: description)
        let navigationController = UINavigationController(rootViewController: appListViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true)
    }
    
    private func showErrorAlert(with message: String?) {
        DispatchQueue.main.async {
            let action = UIAlertAction(title: Namespace.confirm, style: .default)
            let alert = self.createAlert(with: message ?? .init(), action: action)
            self.present(alert, animated: true)
        }
    }
}

extension TodayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 15.0, *) {
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section),
                  let item = dataSource?.itemIdentifier(for: indexPath) else { return }
            viewModel.didTapCellAt(section: section, with: item)
        } else {
            guard let section = TodaySection(rawValue: indexPath.section),
                  let item = dataSource?.itemIdentifier(for: indexPath) else { return }
            viewModel.didTapCellAt(section: section, with: item)
        }
    }
}
