//
//  AppInfoView.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class AppInfoView: UIView {
    private enum Namespace {
        static let get = "GET"
    }
    
    private var viewModel: AppInfoViewModel?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
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
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
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
    
    func bind(with item: TodayItem) {
        viewModel = AppInfoViewModel(item: item)
        viewModel?.imageDataDelivered = { [weak self] data in
            self?.fillImage(with: data)
        }
        viewModel?.fetchIconImage()
        configureContents()
    }
    
    private func configureHierarchy() {
        [iconImageView, appTitleLabel, appCategoryLabel, priceButton].forEach { addSubview($0) }
    }
    
    private func configureConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
        
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            appTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
        ])
        
        appCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appCategoryLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 4),
            appCategoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            appCategoryLabel.leadingAnchor.constraint(equalTo: appTitleLabel.leadingAnchor)
        ])
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceButton.leadingAnchor.constraint(equalTo: appTitleLabel.trailingAnchor, constant: 12),
            priceButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceButton.heightAnchor.constraint(equalToConstant: 32),
            priceButton.widthAnchor.constraint(equalToConstant: 80),
            priceButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configureContents() {
        appTitleLabel.text = viewModel?.appName
        appCategoryLabel.text = viewModel?.appCategory
        priceButton.setTitle(viewModel?.price, for: .normal)
    }
    
    private func fillImage(with data: Data) {
        DispatchQueue.main.async { [weak self] in
            let icon = UIImage(data: data)
            self?.iconImageView.image = icon
        }
    }
}
