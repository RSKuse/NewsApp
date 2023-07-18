//
//  NewsAppTableViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/14.


import Foundation
import UIKit

class NewsAppTableViewCell: UITableViewCell {
    
    lazy var newsAppImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var newsCompanyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Design Boom"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.text = "3h"
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
    
    lazy var newsBulletinDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Greek 'villa earth' emerges from the mediterranean coast like a futuristic yacht"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    lazy var newsBulletinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    lazy var likeImageButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "like_icon")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var likeCommentReadLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "4"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var commentCountLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .lightGray
//        label.text = "2"
//        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var readCountLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .lightGray
//        label.text = "1226"
//        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    lazy var likeCommentReadViewStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [likeCountLabel, commentCountLabel, readCountLabel])
//        stackView.alignment = .leading
//        stackView.distribution = .fillProportionally
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
////        let dotSeparator1 = UILabel()
////        dotSeparator1.textColor = .lightGray
////        dotSeparator1.text = "•"
////        dotSeparator1.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
////
////        stackView.addArrangedSubview(likeCountLabel)
////        stackView.addArrangedSubview(dotSeparator1)
////        stackView.addArrangedSubview(commentCountLabel)
////
////        let dotSeparator2 = UILabel()
////        dotSeparator2.textColor = .lightGray
////        dotSeparator2.text = "•"
////        dotSeparator2.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
////
////        stackView.addArrangedSubview(dotSeparator2)
////        stackView.addArrangedSubview(readCountLabel)
//        return stackView
//    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    func setupUI() {
        addSubview(newsAppImageView)
        addSubview(companyNameTimeStampViewStackView)
        addSubview(newsBulletinImageView)
        addSubview(newsBulletinImageView)
        addSubview(newsBulletinDetailLabel)
        addSubview(likeImageButton)
        addSubview(likeCommentReadLabel)
        
        
        newsAppImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newsAppImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        newsAppImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        newsAppImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        companyNameTimeStampViewStackView.leftAnchor.constraint(equalTo: newsAppImageView.rightAnchor, constant: 10).isActive = true
        companyNameTimeStampViewStackView.centerYAnchor.constraint(equalTo: newsAppImageView.centerYAnchor).isActive = true
        
        newsBulletinImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        newsBulletinImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newsBulletinImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newsBulletinImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        newsBulletinDetailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 22.5).isActive = true
        newsBulletinDetailLabel.topAnchor.constraint(equalTo: newsAppImageView.bottomAnchor, constant: 10).isActive = true
        newsBulletinDetailLabel.rightAnchor.constraint(equalTo: newsBulletinImageView.leftAnchor, constant: -20).isActive = true
        
        
        likeImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 22.5).isActive = true
        likeImageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        likeImageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        likeImageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        likeCommentReadLabel.leftAnchor.constraint(equalTo: likeImageButton.rightAnchor, constant: 5).isActive = true
        likeCommentReadLabel.centerYAnchor.constraint(equalTo: likeImageButton.centerYAnchor).isActive = true
        likeCommentReadLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        likeCommentReadLabel.topAnchor.constraint(equalTo: newsBulletinDetailLabel.bottomAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

