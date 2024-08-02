//
//  CategoryCollectionViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(categoryLabel)
        
        categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = UIColor.systemGray5
        
        // Add shadow for a nicer look
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4
    }
    
    override var isSelected: Bool {
        didSet {
            animateSelection()
        }
    }
    
    func configure(with category: NewsCategories) {
        categoryLabel.text = category.rawValue.capitalized
        contentView.backgroundColor = CategoryColors.color(for: category)
    }
    
    private func animateSelection() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = self.isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            self.categoryLabel.textColor = self.isSelected ? .white : .black
            
        })
    }
}
