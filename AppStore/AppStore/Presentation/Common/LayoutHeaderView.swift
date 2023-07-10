//
//  LayoutHeaderView.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class LayoutHeaderView: UICollectionReusableView {
    private enum Namespace {
        static let userProfileIcon: String = "person.circle"
    }
    
    static var identifier: String { return String(describing: self) }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout, weight: .bold)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let userProfileImageView: UIImageView = {
        let image = UIImage(systemName: Namespace.userProfileIcon)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDate() {
        dateLabel.text = DateFormatter.formatter.string(from: Date()).capitalized
    }
    
    func setTitle(with title: String) {
        titleLabel.text = title
    }
    
    private func configureHierarchy() {
        [dateLabel, titleLabel, userProfileImageView].forEach { addSubview($0) }
    }
    
    private func configureConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            userProfileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor)
        ])
    }
}
