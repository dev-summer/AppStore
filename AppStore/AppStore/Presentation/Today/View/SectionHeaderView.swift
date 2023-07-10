//
//  SectionHeaderView.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static var identifier: String { return String(describing: self) }
    
    private let sectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextFor(description: String?, title: String?) {
        sectionDescriptionLabel.text = description
        sectionTitleLabel.text = title
    }
    
    private func configureHierarchy() {
        [sectionDescriptionLabel, sectionTitleLabel].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        sectionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionDescriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            sectionDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
        
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: sectionDescriptionLabel.bottomAnchor),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}
