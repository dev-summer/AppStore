//
//  DetailSummaryCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/18.
//

import UIKit

final class DetailSummaryCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private enum Namespace {
        static let developerIcon: String = "person.crop.square"
    }
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private let middleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private let middleIconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: Namespace.developerIcon)
        imageView.image = image
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        middleIconImageView.isHidden = true
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topLabel.text = nil
        middleLabel.text = nil
        bottomLabel.text = nil
        middleLabel.isHidden = false
        middleIconImageView.isHidden = true
    }
    
    func bind(with viewModel: DetailSummaryItemModel) {
        topLabel.text = viewModel.topLabelText
        middleLabel.text = viewModel.middleLabelText
        bottomLabel.text = viewModel.bottomLabelText
        
        if viewModel.type == .developer {
            middleLabel.isHidden = true
            middleIconImageView.isHidden = false
        }
    }
    
    private func configureHierarchy() {
        [topLabel, middleLabel, middleIconImageView, bottomLabel].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            middleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        middleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            middleIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            middleIconImageView.widthAnchor.constraint(equalToConstant: 24),
            middleIconImageView.heightAnchor.constraint(equalTo: middleIconImageView.widthAnchor)
        ])
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
