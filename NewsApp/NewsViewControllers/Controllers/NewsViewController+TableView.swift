//
//  ViewController+TableView.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation
import UIKit

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsAppTableViewCell.cellID, for: indexPath) as? NewsAppTableViewCell,
              let articles = viewModel.articles else {
            return UITableViewCell()
        }
        
        let newsArticle = articles[indexPath.row]
        newsCell.configure(with: newsArticle)
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles = viewModel.articles else { return }
        let article = articles[indexPath.row]
        if let urlString = article.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
