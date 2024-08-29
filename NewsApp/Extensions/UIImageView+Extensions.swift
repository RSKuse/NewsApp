//
//  UIImageView+Extensions.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/28.
//

//import Foundation
//import UIKit
//
//extension UIImageView {
//    func loadImage(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error loading image: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data)
//            }
//        }.resume()
//    }
//}
