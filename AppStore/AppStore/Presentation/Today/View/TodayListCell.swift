//
//  TodayListCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class TodayListCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private let infoView: AppInfoView = AppInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with item: TodayItem) {
        infoView.bind(with: item)
    }
    
    private func configureHierarchy() {
        contentView.addSubview(infoView)
    }
    
    private func configureConstraints() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
