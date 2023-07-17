//
//  TodayLargeCell.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class TodayLargeCell: UICollectionViewCell {    
    private let topView: UIView = {
        let view = UIView()
        view.alpha = 0.5
        view.backgroundColor = .systemRed
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
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
        [topView, bottomView].forEach { contentView.addSubview($0) }
        bottomView.addSubview(infoView)
    }
    
    private func configureConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
