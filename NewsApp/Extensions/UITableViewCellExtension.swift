//
//  UITableViewCellExtension.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation
import UIKit

extension UITableViewCell {
   
    static var cellID: String {
        return String(describing: self)
    }
}
