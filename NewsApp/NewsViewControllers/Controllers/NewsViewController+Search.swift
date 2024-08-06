//
//  NewsViewController+Search.swift
//  NewsApp
//
//  Created by Gugulethu Mhlanga on 2024/08/02.
//

import Foundation
import UIKit

extension NewsViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            clearSearchResults()
            return
        }
        
        self.viewModel.isSearching = true
        viewModel.searchQuery = query
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewModel.isSearching  = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.isSearching  = true
        self.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchResults()
    }
    
    private func clearSearchResults() {
        self.viewModel.isSearching = false
        self.viewModel.searchQuery = ""
    }
}
