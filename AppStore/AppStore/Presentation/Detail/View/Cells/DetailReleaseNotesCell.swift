//
//  DetailReleaseNotesCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/18.
//

import UIKit

final class DetailReleaseNotesCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        return label
    }()
    
    private let releaseNotesTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: DetailReleaseNotesItemModel) {
        versionLabel.text = viewModel.currentVersion
        releaseNotesTextView.text = viewModel.releaseNotes
    }
    
    private func configureHierarchy() {
        [versionLabel, releaseNotesTextView].forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        releaseNotesTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseNotesTextView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 8),
            releaseNotesTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            releaseNotesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            releaseNotesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
