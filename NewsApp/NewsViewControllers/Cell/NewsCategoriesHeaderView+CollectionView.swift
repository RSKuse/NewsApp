//
//  NewsCategoriesHeaderView+CollectionView.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/06.
//

import Foundation
import UIKit

extension NewsCategoriesHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellID, for: indexPath) as? CategoryCollectionViewCell,
              let categories = categories else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        cell.configure(with: category, selectedCategory: selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCategory = categories?[indexPath.item] {
            self.selectedCategory = selectedCategory
            didSelectCategory?(selectedCategory)
        }
    }
}
