//
//  NewViewModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

class NewsViewModel {
    
    var articles: [Article]? {
        didSet {
            guard let _ = articles else { return }
            filteredArticles = articles
        }
    }
    
    var filteredArticles: [Article]?
    
    var didFetchArticles: (([Article]?) -> Swift.Void)?
    
    func fetchTopHeadlinesNewsData(category: NewsCategories) {
        let path = "\(NewsType.topHeadlines.rawValue)?country=us&category=\(category.rawValue)"
        NewsService.shared.fetchData(method: HTTPMethods.GET,
                                     baseURl: URLCenter.newsUrl,
                                     path: path,
                                     model: NewsModel.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self.articles = news.articles
                    self.didFetchArticles?(news.articles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
