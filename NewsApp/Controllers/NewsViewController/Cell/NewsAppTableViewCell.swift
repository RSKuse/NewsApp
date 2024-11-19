//
//  NewsAppTableViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/14.


import Foundation
import UIKit
import Kingfisher

class NewsAppTableViewCell: UITableViewCell {
    
    
    lazy var newsSourceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var newsSourceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newSourceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newsSourceImageView, newsSourceNameLabel])
        stackView.alignment = .center
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
    
    lazy var newsArticleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var newsTitleAndArticleImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newsTitleLabel, newsArticleImageView])
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "white")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(newSourceStackView)
        addSubview(newsTitleAndArticleImageStackView)
        addSubview(timeStampLabel)
        
        newSourceStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newSourceStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        newSourceStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        newsSourceImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        newsSourceImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        newsTitleAndArticleImageStackView.leftAnchor.constraint(equalTo: newSourceStackView.leftAnchor).isActive = true
        newsTitleAndArticleImageStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        newsTitleAndArticleImageStackView.topAnchor.constraint(equalTo: newSourceStackView.bottomAnchor, constant: 20).isActive = true
        
        newsArticleImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newsArticleImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        timeStampLabel.leftAnchor.constraint(equalTo: newSourceStackView.leftAnchor).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: newsTitleAndArticleImageStackView.bottomAnchor,
                                            constant: 10).isActive = true
        timeStampLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeStampLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    func configure(with article: Article) {
        newsTitleLabel.text = article.title
        newsSourceNameLabel.text = article.source?.name
        timeStampLabel.text = article.publishedAt?.formattedRelativeDate()
        // likeCommentReadLabel.text = "\(article.likesCount ?? 0) Likes"
        
        if let sourceImage = article.getNewsSourceImage() {
            newsSourceImageView.image = sourceImage
            newsSourceImageView.isHidden = false
        }
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            self.newsArticleImageView.kf.setImage(with: url)
            self.newsArticleImageView.isHidden = false
        } else {
            self.newsArticleImageView.image = UIImage(named: "placeholder")
            self.newsArticleImageView.isHidden = false
        }
    }
}
        
        
//        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
//            DispatchQueue.global().async{
//                let data = try? Data(contentsOf: url)
//                if let imageData = data {
//                    DispatchQueue.main.async {
//                        self.newsArticleImageView.image = UIImage(data: imageData)
//                        self.newsArticleImageView.isHidden = false
//                    }
//                    
//                }
//                
//            }
//        }
