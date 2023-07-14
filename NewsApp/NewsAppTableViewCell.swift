//
//  NewsAppTableViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/14.
//

import Foundation

import UIKit

class NewsAppTableViewCell: UITableViewCell {
    
//    lazy var followerImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 30
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .red
//        return imageView
//    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

