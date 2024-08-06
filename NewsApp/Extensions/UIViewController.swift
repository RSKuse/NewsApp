//
//  UIViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/06.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationTitle(withTitle title:String,
                            font: UIFont = UIFont.boldSystemFont(ofSize: 15),
                            titleColour: UIColor = UIColor.black) {
        let navBarTitleLabel = UILabel()
        navBarTitleLabel.textAlignment = .center
        navBarTitleLabel.text = title
        navBarTitleLabel.textColor = titleColour
        navBarTitleLabel.font = font
        self.navigationItem.titleView = navBarTitleLabel
    }
    
    func navigationNoLineBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController?.navigationController?.navigationBar.prefersLargeTitles = false
        appDelegate.window?.rootViewController?.navigationController?.navigationItem.largeTitleDisplayMode = .never
        
    }
}
