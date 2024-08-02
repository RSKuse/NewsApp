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
        
        /*
        let transactions = self.viewModel.fetchedTransactions.filter({ (transaction: Transaction) -> Bool in
            
            var operatorName = ""
            if let merchantID = transaction.merchantID, let operatorID = Int(merchantID) {
                operatorName = LocalService.operatorName(operatorID: operatorID).uppercased()
            }
            
            let transactionDate = DateManager.dayDateMonthTime.stringFrom(date: transaction.date)
            
            var transactionDateSettled = ""
            if let dateSettled = transaction.dateSettled {
                transactionDateSettled = DateManager.dayDateMonthTime.stringFrom(date: dateSettled)
            }
            
            return transaction.merchantID!.lowercased().contains(query.trimmedWhitespaces.lowercased()))
        })
        
        self.viewModel.searchedArticles.value = transactions
        */
        
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
        self.viewModel.searchedArticles?.removeAll()
        self.newsTableView.reloadData()
    }
}
