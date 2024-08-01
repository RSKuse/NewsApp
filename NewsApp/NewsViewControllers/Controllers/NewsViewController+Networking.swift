//
//  NewsViewController+Networking.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

extension NewsViewController {
    
    @objc func fetchNews() {
        loadingIndicator.startAnimating()
        viewModel.fetchTopHeadlinesNewsData(category: NewsCategories.science)
    }
    
    func listenForNewsArticlesFetched() {
        viewModel.didFetchArticles = { [weak self] news in
            guard let self else { return }
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.newsTableView.reloadData()
        }
    }
    
    func listenForErrorReturned() {
        
    }
}
