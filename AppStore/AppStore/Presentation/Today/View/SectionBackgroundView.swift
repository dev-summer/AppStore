//
//  SectionBackgroundView.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    static var identifier: String { return String(describing: self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 16
        backgroundColor = .secondarySystemBackground
    }
}
