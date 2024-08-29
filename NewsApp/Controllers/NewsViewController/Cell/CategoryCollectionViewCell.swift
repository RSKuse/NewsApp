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
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        categoryLabel.textColor = .black
        categoryIconImageView.tintColor = .black
    }

    func configure(with category: NewsCategories, selectedCategory: NewsCategories?) {
        categoryLabel.text = category.rawValue.capitalized

        // Assign the relevant icon for each category
        switch category {
        case .business:
            categoryIconImageView.image = UIImage(named: "ic_business")?.withRenderingMode(.alwaysTemplate)
        case .sports:
            categoryIconImageView.image = UIImage(named: "ic_sports")?.withRenderingMode(.alwaysTemplate)
        case .politics:
            categoryIconImageView.image = UIImage(named: "ic_politics")?.withRenderingMode(.alwaysTemplate)
        case .technology:
            categoryIconImageView.image = UIImage(named: "ic_technology")?.withRenderingMode(.alwaysTemplate)
        case .health:
            categoryIconImageView.image = UIImage(named: "ic_health")?.withRenderingMode(.alwaysTemplate)
        case .science:
            categoryIconImageView.image = UIImage(named: "ic_science")?.withRenderingMode(.alwaysTemplate)
        case .entertainment:
            categoryIconImageView.image = UIImage(named: "ic_entertainment")?.withRenderingMode(.alwaysTemplate)
        default:
            categoryIconImageView.image = UIImage(named: "ic_general")?.withRenderingMode(.alwaysTemplate)
        }

        let isSelectedCategory = selectedCategory?.rawValue == category.rawValue
        self.categoryLabel.textColor = isSelectedCategory ? .white : .black
        self.categoryIconImageView.tintColor = isSelectedCategory ? .white : .black
        self.backgroundColor = isSelectedCategory ? .black : UIColor(white: 0.9, alpha: 1.0)
    }

    private func animateOnSelection() {
        UIView.animate(withDuration: 0.1, animations: {
            self.categoryLabel.textColor = self.isSelected ? .white : .black
            self.categoryIconImageView.tintColor = self.isSelected ? .white : .black
            self.backgroundColor = self.isSelected ? .black : UIColor(white: 0.9, alpha: 1.0)
            self.layoutIfNeeded()
        }, completion: nil)
    }

    private func animateOnHighlight() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
            self.backgroundColor = self.isHighlighted ? UIColor.black : UIColor(white: 0.9, alpha: 1.0)
            self.categoryIconImageView.tintColor = self.isHighlighted ? .white : .black
            self.categoryLabel.textColor = self.isHighlighted ? .white : .black
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
