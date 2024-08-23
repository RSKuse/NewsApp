//
//  NewViewModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

class NewsViewModel {
    
    var selectedCagory: NewsCategories = .general
    
    let categories: [NewsCategories] = [.general, .business, .sports, .politics, .technology, .health, .science, .entertainment]
    let countries: [NewsCountry] = [.za, .us, .gb, .ca, .ch, .fr, .ru, .ae, .ar, .at, .au, .be, .bg, .br, .cn, .co, .cu, .cz, .de, .eg, .gr, .hk, .hu, .id, .ie, .il, .india, .it, .jp, .kr, .lt, .lv, .ma, .mx, .my, .ng, .nl, .no, .nz, .ph, .pl, .pt, .ro, .rs, .se, .sg, .si, .sk, .th, .tr, .tw, .ua, .ve]
    
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
     Computed Propperties (variable that return something)
     */
    var selectedCountry: NewsCountry {
        /*
        if let country = UserDefaultsManager.shared.fetchValue(withKey: .country) {
            guard let countryString = country as? String else {
                return .za
            }
            return NewsCountry(rawValue: countryString) ?? .za
        }
        */
        if let country = UserDefaultsManager.shared.fetchValue(withKey: .country),
           let countryString = country as? String {
            return NewsCountry(rawValue: countryString) ?? .za
        }
        return .za
    }
    
    /**
     Computed Properties Example
     */
    var a = 29
    var b: Int {
        let g = 90
        let f = 79
        let division = 10 / 4
        return (g + f) * division
    }
    
    func fetchTopHeadlinesNewsData(category: NewsCategories) {
        // Check if the cache should be ignored (e.g., when the country changes)
        let shouldIgnoreCache = categoryArticlesCache[category]?.first?.source?.name != selectedCountry.rawValue
        
        if !shouldIgnoreCache, let cachedArticles = categoryArticlesCache[category] {
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
