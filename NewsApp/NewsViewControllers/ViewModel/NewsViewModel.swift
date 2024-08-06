//
//  NewViewModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

class NewsViewModel {
    
    var selectedCagory: NewsCategories = .general
    
    let categories: [NewsCategories] = [.business, .sports, .politics, .technology, .health, .science, .entertainment, .general]
    let countries: [NewsCountry] = [.za, .us, .gb, .ca, .ch, .fr, .ru]
    
    /**
     - Search News Data
     */
    var isSearching = false
    var searchedArticles: [Article] = []
    var didSearchArticles: (([Article]?) -> Void)?
    var searchQuery: String = "" {
        didSet {
            if searchQuery.isEmpty {
                self.isSearching = false
                self.searchedArticles.removeAll()
            }
            
            if !self.articles.isEmpty {
                
                let searchedArticles = self.articles.filter({ (article: Article) -> Bool in
                    return article.title?.lowercased().contains(searchQuery.lowercased()) ?? false
                })
                
                self.searchedArticles = searchedArticles
                self.didSearchArticles?(searchedArticles)
            }
        }
    }
    
    /**
     - Fetch News Data
     */
    var articles: [Article] = []
    var didFetchArticles: (([Article]?) -> Void)?
    
    /**
     Computed Propperties
     */
    var selectedCountry: NewsCountry {
        if let country = UserDefaultStorage.country.fetchValue() {
            return NewsCountry(rawValue: country) ?? .za
        }
        return .za
    }
    
    func fetchTopHeadlinesNewsData(category: NewsCategories) {
        let path = "\(NewsType.topHeadlines.rawValue)?country=\(selectedCountry.rawValue)&category=\(category.rawValue)"
        NewsService.shared.fetchData(method: .GET, baseURl: .newsUrl, path: path, model: NewsModel.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self.articles = news.articles ?? []
                    self.didFetchArticles?(news.articles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
