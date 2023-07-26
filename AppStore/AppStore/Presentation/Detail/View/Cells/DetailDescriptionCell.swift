//
//  DetailDescriptionCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/18.
//

import UIKit

final class DetailDescriptionCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .caption1)
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
    
    func bind(with viewModel: DetailDescriptionItem) {
        textView.text = viewModel.description
    }
    
    private func configureHierarchy() {
        contentView.addSubview(textView)
    }
    
    private func configureConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
