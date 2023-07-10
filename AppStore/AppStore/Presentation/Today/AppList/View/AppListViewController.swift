//
//  AppListViewController.swift
//  AppStore
//
//  Created by summercat on 2023/07/10.
//

import UIKit

final class AppListViewController: UIViewController {
    private enum Namespace {
        static let closeButtonIcon: String = "xmark.circle.fill"
        static let buttonBackground: String = "circle.fill"
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TodayItem>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TodayItem>
    
    private let viewModel: AppListViewModel
    private var dataSource: DataSource?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: Namespace.closeButtonIcon, withConfiguration: iconConfig)?
            .withRenderingMode(.alwaysTemplate)
        let background = UIImage(systemName: Namespace.buttonBackground)?
            .withTintColor(.systemBackground, renderingMode: .alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = .secondarySystemBackground
        button.setBackgroundImage(background, for: .normal)
        return button
    }()
    
    init(viewModel: AppListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureNavigationBar()
        configureHierarchy()
        configureConstraints()
        configureCollectionView()
        configureCloseButtonAction()
        bind()
        viewModel.fetchAppList()
    }
    
    private func configureStatusBar() {
        navigationController?.modalPresentationCapturesStatusBarAppearance = true
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func configureHierarchy() {
        [collectionView, closeButton].forEach { view.addSubview($0) }
    }
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDataSource()
        registerSupplementaryViews()
        configureSupplementaryViews()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, environment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let header = self.createSectionHeaderItem()
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
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
        
        return header
    }
    
    private func registerSupplementaryViews() {
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
    }
    
    private func configureSupplementaryViews() {
        dataSource?.supplementaryViewProvider = { [weak self] _, _, indexPath in
            return self?.createSectionHeaderView(indexPath)
        }
    }
    
    private func createSectionHeaderView(_ indexPath: IndexPath) -> SectionHeaderView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        ) as? SectionHeaderView else { return nil }
        
        header.setTextFor(description: viewModel.description, title: viewModel.title)
        
        return header
    }
    
    private func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<TodayListCell, TodayItem> { cell, _, item in
          cell.bind(with: item)
        }
        
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: listCellRegistration,
                    for: indexPath,
                    item: item
                )
            })
    }
    
    private func configureCloseButtonAction() {
        let action = UIAction { _ in
            self.dismiss(animated: true)
        }
        closeButton.addAction(action, for: .allTouchEvents)
    }
    
    private func bind() {
        viewModel.appsDelivered = { [weak self] items in
            var snapshot = Snapshot()
            snapshot.appendSections([.list])
            snapshot.appendItems(items, toSection: .list)
            self?.dataSource?.apply(snapshot)
        }
        viewModel.cellTapped = { [weak self] viewModel in
            self?.showAppDetail(with: viewModel)
        }
    }
    
    private func showAppDetail(with viewModel: DetailViewModel) {
        let detailViewController = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension AppListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapCell(with: item)
    }
}

extension AppListViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension UINavigationController {
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
}