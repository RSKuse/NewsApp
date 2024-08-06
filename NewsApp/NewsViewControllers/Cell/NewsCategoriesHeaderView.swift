//
//  NewsCategoriesHeaderView.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/06.
//

import Foundation
import UIKit

class NewsCategoriesHeaderView: UIView {
    
    var selectedCategory: NewsCategories?
    
    var categories: [NewsCategories]? {
        didSet {
            if categories != nil {
                categoryCollectionView.reloadData()
            }
        }
    }
    
    var didSelectCategory: ((NewsCategories) -> Void)?
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 5,
                                           left: 20,
                                           bottom: 5,
                                           right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellID)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(categoryCollectionView)
        
        categoryCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
