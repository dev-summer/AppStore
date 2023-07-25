//
//  DetailInformationCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/18.
//

import UIKit

final class DetailInformationCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        return label
    }()
    
    private let itemInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: DetailInformationItemModel) {
        itemNameLabel.text = viewModel.itemName
        itemInformationLabel.text = viewModel.itemInformation
    }
    
    private func configureHierarchy() {
        [itemNameLabel, itemInformationLabel].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        itemInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemInformationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemInformationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemInformationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: itemNameLabel.trailingAnchor, constant: 4),
            itemInformationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
