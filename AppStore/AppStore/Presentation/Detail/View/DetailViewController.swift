//
//  DetailViewController.swift
//  AppStore
//
//  Created by summercat on 2023/07/11.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    init(appID: Int) {
        self.viewModel = DetailViewModel(appID: appID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
