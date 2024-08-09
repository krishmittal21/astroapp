//
//  HomeViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var settingsButton: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var moonImage: UIImageView!
    @IBOutlet weak var articlesHeading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articlesPreviewVC = ArticlesPreviewViewController()
        addChild(articlesPreviewVC)
        view.addSubview(articlesPreviewVC.view)
        articlesPreviewVC.didMove(toParent: self)
        
        articlesPreviewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articlesPreviewVC.view.topAnchor.constraint(equalTo: articlesHeading.bottomAnchor, constant: 8),
            articlesPreviewVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articlesPreviewVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            articlesPreviewVC.view.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
}
