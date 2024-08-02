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
        viewModel.fetchTopHeadlinesNewsData(category: NewsCategories.general)
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
    
    func fetchNewsForCountry(_ country: NewsCountry) {
        loadingIndicator.startAnimating()
        let selectedCategory = viewModel.categories[categoryCollectionView.indexPathsForSelectedItems?.first?.item ?? 0]
        viewModel.fetchTopHeadlinesNewsData(category: selectedCategory, country: country)
    }
}
