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
    let countries: [NewsCountry] = [.za, .us, .gb, .ca, .ch, .fr, .ru, .ae, .ar, .at, .au, .be, .bg, .br, .cn, .co, .cu, .cz, .de, .eg, .gr, .hk, .hu, .id, .ie, .il, .ind, .it, .jp, .kr, .lt, .lv, .ma, .mx, .my, .ng, .nl, .no, .nz, .ph, .pl, .pt, .ro, .rs, .se, .sg, .si, .sk, .th, .tr, .tw, .ua, .ve]
    
    // Cache for storing articles by category
    private var categoryArticlesCache: [NewsCategories: [Article]] = [:]
    
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
        // Check if articles are already cached for the selected category
        if let cachedArticles = categoryArticlesCache[category] {
            print("Loaded cached articles for category: \(category.rawValue)")
            self.articles = cachedArticles
            self.didFetchArticles?(cachedArticles)
        } else {
            // If not cached, fetch from network
            let path = "\(NewsType.topHeadlines.rawValue)?country=\(selectedCountry.rawValue)&category=\(category.rawValue)"
            NewsService.shared.fetchData(method: .GET, baseURl: .newsUrl, path: path, model: NewsModel.self) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let news):
                        self.articles = news.articles ?? []
                        self.categoryArticlesCache[category] = news.articles ?? []
                        self.didFetchArticles?(news.articles)
                        print("Fetched and cached articles for category: \(category.rawValue)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
