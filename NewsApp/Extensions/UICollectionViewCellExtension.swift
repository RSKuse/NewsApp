//
//  UICollectionViewCellExtension.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/02.
//

import Foundation
import UIKit

extension UICollectionViewCell {
   
    static var cellID: String {
        return String(describing: self)
    }
}
