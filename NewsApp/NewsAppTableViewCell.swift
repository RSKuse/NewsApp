//
//  NewsAppTableViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/14.


import Foundation
import UIKit

class NewsAppTableViewCell: UITableViewCell {
    
    var likesCount = 0
    
    lazy var newsAppImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var newsCompanyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var companyNameTimeStampViewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newsCompanyNameLabel, timeStampLabel])
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var newsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newsBulletinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var likeImageButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(systemName: "heart")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likeCommentReadLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Likes"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(newsAppImageView)
        addSubview(companyNameTimeStampViewStackView)
        addSubview(newsBulletinImageView)
        addSubview(newsTitleLabel)
        addSubview(likeImageButton)
        addSubview(likeCommentReadLabel)
        
        NSLayoutConstraint.activate([
            newsAppImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            newsAppImageView.heightAnchor.constraint(equalToConstant: 25),
            newsAppImageView.widthAnchor.constraint(equalToConstant: 25),
            newsAppImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            companyNameTimeStampViewStackView.leftAnchor.constraint(equalTo: newsAppImageView.rightAnchor, constant: 10),
            companyNameTimeStampViewStackView.centerYAnchor.constraint(equalTo: newsAppImageView.centerYAnchor),
            
            newsBulletinImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            newsBulletinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsBulletinImageView.heightAnchor.constraint(equalToConstant: 80),
            newsBulletinImageView.widthAnchor.constraint(equalToConstant: 80),
            
            newsTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 22.5),
            newsTitleLabel.topAnchor.constraint(equalTo: newsAppImageView.bottomAnchor, constant: 10),
            newsTitleLabel.rightAnchor.constraint(equalTo: newsBulletinImageView.leftAnchor, constant: -20),
            
            likeImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 22.5),
            likeImageButton.heightAnchor.constraint(equalToConstant: 25),
            likeImageButton.widthAnchor.constraint(equalToConstant: 25),
            likeImageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            likeCommentReadLabel.leftAnchor.constraint(equalTo: likeImageButton.rightAnchor, constant: 5),
            likeCommentReadLabel.centerYAnchor.constraint(equalTo: likeImageButton.centerYAnchor),
            likeCommentReadLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            likeCommentReadLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(with article: Article) {
        newsTitleLabel.text = article.title
        newsCompanyNameLabel.text = article.source?.name
        timeStampLabel.text = article.publishedAt?.formattedRelativeDate()
        likeCommentReadLabel.text = "\(article.likesCount ?? 0) Likes"
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
        
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                newsAppImageView.image = UIImage(data: imageData)
                newsBulletinImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    @objc func handleLikeButtonTapped() {
        print("Like button tapped")
        likesCount += 1
        likeCommentReadLabel.text = "\(likesCount) Likes"
        likeImageButton.tintColor = .systemRed
        
    }
}
