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
    
    func setupNavigationBar() {
        self.title = "News"
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            appearance.largeTitleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 32, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.backgroundColor = .white
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.prefersLargeTitles = true
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            navigationController?.navigationBar.titleTextAttributes = titleAttributes
            navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        }
        
        navigationController?.setStatusBar(backgroundColor: .white)
    }

}
