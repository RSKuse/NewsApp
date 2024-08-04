//
//  ViewController+TableView.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation
import UIKit
import SafariServices

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.isSearching {
            return nil
        }
        let headerView = NewsCategoriesHeaderView()
        headerView.categories = viewModel.categories
        headerView.didSelectCategory = { category in
            self.viewModel.selectedCagory = category
            self.fetchNewsForCategory(category)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.isSearching ? 0.0 : 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.searchedArticles.count : viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsAppTableViewCell.cellID, for: indexPath) as? NewsAppTableViewCell else {
            return UITableViewCell()
        }
        
        if viewModel.isSearching {
            let newsArticle = viewModel.searchedArticles[indexPath.row]
            newsCell.configure(with: newsArticle)
        } else {
            let newsArticle = viewModel.articles[indexPath.row]
            newsCell.configure(with: newsArticle)
        }
        
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        
        if let urlString = article.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
        */
        
        // Another way to open a URL that will keep you in the app without necessarily openning Safari
        var article = viewModel.articles[indexPath.row]
        if viewModel.isSearching {
            article = viewModel.searchedArticles[indexPath.row]
        } else {
            article = viewModel.articles[indexPath.row]
        }
        
        guard let urlString = article.url,
                  let url = URL(string: urlString) else { return }
        let safariController = SFSafariViewController(url: url as URL)
        safariController.preferredControlTintColor = UIColor.black
        present(safariController, animated: true, completion: nil)
        
    }
}
