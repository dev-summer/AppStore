//
//  DetailViewController.swift
//  AppStore
//
//  Created by summercat on 2023/07/11.
//

import UIKit

final class DetailViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<DetailSection, DetailItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailItem>

    private let viewModel: DetailViewModel
    private let sections: [DetailLayoutSection] = [
        DetailTopSection(),
        DetailSummarySection(),
        DetailScreenshotSection(),
        DetailDescriptionSection(),
        DetailReleaseNotesSection(),
        DetailInformationSection()
    ]
    private var dataSource: DataSource?
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray
        return imageView
    }()

    init(app: App) {
        self.viewModel = DetailViewModel(app: app)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureConstraints()
        configureViewController()
        configureCollectionView()
        bind(with: viewModel)
    }
    
    private func bind(with viewModel: DetailViewModel) {
        viewModel.imageDataDelivered = { [weak self] data in
            self?.configureNavigationBar(with: data)
        }
        viewModel.fetchIconImage()
        applyData(with: viewModel)
    }
    
    private func applyData(with viewModel: DetailViewModel) {
        var snapshot = Snapshot()
        let sections = DetailSection.allCases.filter { $0.isValid(for: viewModel.app) }
        snapshot.appendSections(sections)
        viewModel.items.forEach { snapshot.appendItems([$0.item], toSection: $0.section) }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureNavigationBar(with data: Data) {
        DispatchQueue.main.async {
            let image = UIImage(data: data)
            self.iconImageView.image = image
            self.navigationItem.titleView = self.iconImageView
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - CollectionView

    private func configureCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        registerCells()
        registerSupplementaryViews()
        configureDataSource()
        configureHeader()
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.sections[sectionIndex].section(environment)
        }
        layout.configuration.interSectionSpacing = 16

        return layout
    }
    
    private func registerCells() {
        collectionView.register(DetailTopCell.self, forCellWithReuseIdentifier: DetailTopCell.identifier)
        collectionView.register(DetailSummaryCell.self, forCellWithReuseIdentifier: DetailSummaryCell.identifier)
        collectionView.register(DetailScreenshotCell.self, forCellWithReuseIdentifier: DetailScreenshotCell.identifier)
        collectionView.register(DetailDescriptionCell.self, forCellWithReuseIdentifier: DetailDescriptionCell.identifier)
        collectionView.register(DetailReleaseNotesCell.self, forCellWithReuseIdentifier: DetailReleaseNotesCell.identifier)
        collectionView.register(DetailInformationCell.self, forCellWithReuseIdentifier: DetailInformationCell.identifier)
    }
    
    private func registerSupplementaryViews() {
        collectionView.register(
            LineHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LineHeaderView.identifier
        )
        collectionView.register(
            DetailSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailSectionHeaderView.identifier
        )
    }
    
    private func configureHeader() {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            return self?.sections[indexPath.section].header(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    // MARK: DataSource
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
            return self?.sections[indexPath.section]
                    .cell(collectionView: collectionView, indexPath: indexPath, item: item)
        })
    }
}
