//
//  UINavigationController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation
import UIKit

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        statusBarView.tintColor = UIColor.black
        view.addSubview(statusBarView)
    }

}
