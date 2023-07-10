//
//  SectionBackgroundView.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    static var identifier: String { return String(describing: self) }
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(backgroundView)
    }
    
    private func configureConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
