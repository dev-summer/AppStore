//
//  DetailLayoutSection.swift
//  AppStore
//
//  Created by summercat on 2023/07/18.
//

import UIKit

protocol DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell
    
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView?
}

extension DetailLayoutSection {
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
}

struct DetailTopSection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailTopCell.identifier,
            for: indexPath
        ) as? DetailTopCell else { return UICollectionViewCell() }
        
        switch item {
        case .top(let detailTopItemModel):
            cell.bind(with: detailTopItemModel)
            detailTopItemModel.fetchIconImage()
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

struct DetailSummarySection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .absolute(60))
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: .zero)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailSummaryCell.identifier,
            for: indexPath
        ) as? DetailSummaryCell else { return UICollectionViewCell() }
        
        switch item {
        case .summary(let detailSummaryItemModel):
            cell.bind(with: detailSummaryItemModel)
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LineHeaderView.identifier, for: indexPath
        ) as? LineHeaderView else { return nil }
        
        return header
    }
}

struct DetailScreenshotSection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(240), heightDimension: .absolute(426))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailScreenshotCell.identifier,
            for: indexPath
        ) as? DetailScreenshotCell else { return UICollectionViewCell() }
        
        switch item {
        case .screenshot(let detailScreenshotItemModel):
            cell.bind(with: detailScreenshotItemModel)
            detailScreenshotItemModel.fetchScreenshot()
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

struct DetailDescriptionSection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailDescriptionCell.identifier,
            for: indexPath
        ) as? DetailDescriptionCell else { return UICollectionViewCell() }
        
        switch item {
        case .description(let detailDescriptionItemModel):
            cell.bind(with: detailDescriptionItemModel)
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LineHeaderView.identifier, for: indexPath
        ) as? LineHeaderView else { return nil }
        
        return header
    }
}

struct DetailReleaseNotesSection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailReleaseNotesCell.identifier,
            for: indexPath
        ) as? DetailReleaseNotesCell else { return UICollectionViewCell() }
        
        switch item {
        case .releaseNote(let detailReleaseNotesItemModel):
            cell.bind(with: detailReleaseNotesItemModel)
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailSectionHeaderView.identifier,
            for: indexPath
        ) as? DetailSectionHeaderView else { return nil }
        
        header.setTitle(with: "What's New")
        
        return header
    }
}

struct DetailInformationSection: DetailLayoutSection {
    func section(_ environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: .zero, trailing: 16)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        return section
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: DetailItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailInformationCell.identifier,
            for: indexPath
        ) as? DetailInformationCell else { return UICollectionViewCell() }
        
        switch item {
        case .information(let detailInformationItemModel):
            cell.bind(with: detailInformationItemModel)
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func header(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailSectionHeaderView.identifier,
            for: indexPath
        ) as? DetailSectionHeaderView else { return nil }
        
        header.setTitle(with: "Information")
        
        return header
    }
}
