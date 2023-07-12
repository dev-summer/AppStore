//
//  RootTabBarController.swift
//  AppStore
//
//  Created by summercat on 2023/07/03.
//

import UIKit

final class RootTabBarController: UITabBarController {
    private enum Constant {
        enum Tabs {
            static let firstTabName: String = "Today"
            static let firstTabIcon: String = "doc.text.image"
        }
    }
    
    private var tabs: [UIViewController]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    private func configureTabs() {
        createNewTab(
            rootViewController: TodayViewController(),
            tabName: Constant.Tabs.firstTabName,
            iconName: Constant.Tabs.firstTabIcon
        )
        viewControllers = tabs
    }
    
    private func createNewTab(
        rootViewController: UIViewController,
        tabName title: String,
        iconName: String
    ) {
        let tab = UINavigationController(rootViewController: rootViewController)
        tab.tabBarItem.title = title
        tab.tabBarItem.image  = UIImage(systemName: iconName)
        tabs?.append(tab)
    }
}
