//
//  AAArticlePreviewCard.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

class AAArticlePreviewCard: UIView {
    private let imageView: UIImageView
    private let titleLabel: UILabel
    private let overlayView: UIView
    
    init(article: AAArticles) {
        imageView = UIImageView()
        titleLabel = UILabel()
        overlayView = UIView()
        
        super.init(frame: .zero)
        
        setupView()
        configure(with: article)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        addSubview(imageView)
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.layer.cornerRadius = 10
        addSubview(overlayView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func configure(with article: AAArticles) {
        titleLabel.text = article.title
        
        if let imageURL = URL(string: article.imageURL ?? "") {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
}
