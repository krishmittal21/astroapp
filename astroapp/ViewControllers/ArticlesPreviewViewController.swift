//
//  ArticlesPreviewViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

class ArticlesPreviewViewController: UIViewController {
    private let scrollView: UIScrollView
    private let stackView: UIStackView
    
    init() {
        scrollView = UIScrollView()
        stackView = UIStackView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadArticles()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func loadArticles() {
        for article in AAArticles.examples {
            let cardView = AAArticlePreviewCard(article: article)
            cardView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            stackView.addArrangedSubview(cardView)
        }
    }
}
