//
//  DetailTopCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/12.
//

import UIKit

final class DetailTopCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private enum Namespace {
        static let shareButtonIcon: String = "square.and.arrow.up"
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let appCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote, weight: .bold)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Namespace.shareButtonIcon)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with item: DetailTopItemModel) {
        item.imageDataDelivered = { [weak self] data in
            self?.fillImage(with: data)
        }
        item.fetchIconImage()
        configureContents(with: item)
    }
    
    private func configureHierarchy() {
        [iconImageView, appTitleLabel, appCategoryLabel, priceButton, shareButton].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
        
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            appTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            appTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        appCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appCategoryLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 4),
            appCategoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16)
        ])
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            priceButton.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            priceButton.widthAnchor.constraint(equalToConstant: 80),
            priceButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 32),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor)
        ])
    }
    
    private func fillImage(with data: Data) {
        DispatchQueue.main.async { [weak self] in
            let icon = UIImage(data: data)
            self?.iconImageView.image = icon
        }
    }
    
    private func configureContents(with item: DetailTopItemModel) {
        appTitleLabel.text = item.appName
        appCategoryLabel.text = item.appCategory
        priceButton.setTitle(item.price, for: .normal)
    }
}
