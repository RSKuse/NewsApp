//
//  NewsViewController+Networking.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation
import UIKit

extension NewsViewController {
    
    @objc func fetchNews() {
        loadingIndicator.startAnimating()
        viewModel.fetchTopHeadlinesNewsData(category: .general)
        viewModel.fetchEverythingNews(category: .general)
    }
    
    func listenForErrorReturned() {
        
    }
    
    func listenForNewsArticlesFetched() {
        viewModel.didFetchArticles = { [weak self] news in
            guard let self else { return }
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if let article = self.viewModel.parallaxHeaderArticle,
               let imageUrl = viewModel.topHeadlinesArticles.first?.urlToImage,
                let url = URL(string: imageUrl) {
                self.topHeaderlineImageView.kf.setImage(with: url)
                self.headlineLabel.text = article.title
            }
            self.newsTableView.reloadData()
        }
    }

    func listenForSearchedArticles() {
        viewModel.didSearchArticles = { [weak self] news in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            self.newsTableView.reloadData()
        }
    }
    
    @objc func refreshNews() {
        /**
         - The problem with this approach is that is uses the UI to check which article is selected. It should be using data instead
        let selectedCategory = viewModel.categories[categoryCollectionView.indexPathsForSelectedItems?.first?.item ?? 0]
        fetchNewsForCategory(selectedCategory)
        */
        
        let selectedCategory = viewModel.selectedCagory
        fetchNewsForCategory(selectedCategory)
    }
    
    func fetchNewsForCountry() {
        /**
         - The problem with this approach is that is uses the UI to check which article is selected. It should be using data instead
        loadingIndicator.startAnimating()
        let selectedCategory = viewModel.categories[categoryCollectionView.indexPathsForSelectedItems?.first?.item ?? 0]
        viewModel.fetchTopHeadlinesNewsData(category: selectedCategory, country: country)
        */
        
        let selectedCategory = viewModel.selectedCagory
        viewModel.fetchTopHeadlinesNewsData(category: selectedCategory)
        viewModel.fetchEverythingNews(category: selectedCategory)
    }
    
    func fetchNewsForCategory(_ category: NewsCategories) {
        loadingIndicator.startAnimating()
        viewModel.fetchTopHeadlinesNewsData(category: category)
        viewModel.fetchEverythingNews(category: category)
    }
    
//    func countryDidChange() {
//        updateSettingsButton()
//    }
    func didSelectCountry(_ country: NewsCountry) {
        UserDefaultsManager.shared.storeValue(country.rawValue, key: .country)
        fetchNewsForCountry()
       // updateSettingsButton()
        
        // Update the custom view with the new country
        if let countrySelectionView = navigationItem.rightBarButtonItem?.customView as? CountrySelectionView {
            let flagImage = UIImage(named: "flag_\(country.rawValue)")
            countrySelectionView.configure(flag: flagImage, countryCode: country.rawValue.uppercased())
        }
    }
    
    func fetchNewsForCountry(_ country: NewsCountry) {
        UserDefaultsManager.shared.storeValue(country.rawValue, key: .country)
        viewModel.fetchTopHeadlinesNewsData(category: viewModel.selectedCagory)
        viewModel.fetchEverythingNews(category: viewModel.selectedCagory)
    }

}
