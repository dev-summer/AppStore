//
//  UIFont+Weight.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import UIKit

extension UIFont {
    static func preferredFont(forTextStyle style: TextStyle, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            .addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: weight]
            ])
        
        return UIFont(descriptor: descriptor, size: .zero)
    }
}
