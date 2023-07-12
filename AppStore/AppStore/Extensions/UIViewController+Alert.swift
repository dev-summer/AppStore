//
//  UIViewController+Alert.swift
//  AppStore
//
//  Created by summercat on 2023/07/11.
//

import UIKit

extension UIViewController {
    func createAlert(with message: String, action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(action)
        
        return alert
    }
}
