//
//  NewsService.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/07/31.
//

import Foundation

class NewsService {
    static let shared = NewsService()
    
    private init() {}
    
    func fetchNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7fcc5fd64d5f428aa1c7c7176527023b")!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                // Print the raw JSON response
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    print("JSON Response: \(json)")
                } else {
                    print("Unable to convert data to JSON object")
                }
                
                let news = try JSONDecoder().decode(NewsModel.self, from: data)
                completion(.success(news.articles ?? []))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
