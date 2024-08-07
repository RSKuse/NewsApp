//
//  CategoryCollectionViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            animateOnSelection()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            animateOnHighlight()
        }
    }
    
    lazy var categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_sports")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryIconImageView, categoryLabel])
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(categoryStackView)
        
        categoryIconImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        categoryIconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        categoryStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        categoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        
        
        layer.cornerRadius = 14
        backgroundColor = UIColor.groupTableViewBackground
        
        /*
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = UIColor.systemGray5
        
        // Add shadow for a nicer look
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4
        */
    }
    
    func configure(with category: NewsCategories, selectedCategory: NewsCategories?) {
        categoryLabel.text = category.rawValue.capitalized
        self.categoryLabel.textColor = selectedCategory?.rawValue == category.rawValue ? .white : .black
        self.categoryIconImageView.tintColor = selectedCategory?.rawValue == category.rawValue ? .white : .black
        self.backgroundColor = selectedCategory?.rawValue == category.rawValue ? .black : .groupTableViewBackground
    }
    
    private func animateOnSelection() {
        UIView.animate(withDuration: 0.1, animations: {
            self.categoryLabel.textColor = self.isSelected ? .white : .black
            self.categoryIconImageView.tintColor = self.isSelected ? .white : .black
            self.backgroundColor = self.isSelected ? .black : .groupTableViewBackground
            // backgroundColor = CategoryColors.color(for: category)
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func animateOnHighlight() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
            self.backgroundColor = self.isHighlighted ? UIColor.black : UIColor.groupTableViewBackground
            self.categoryIconImageView.tintColor = self.isHighlighted ? .white : .black
            self.categoryLabel.textColor = self.isHighlighted ? .white : .black
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
