//
//  NewsService.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/07/31.
//

import Foundation

class NewsService {
    
    // Singleton
    static let shared = NewsService()
    
    private init() {}
    
    /**
     - Generic API call
     */
    

    
    func fetchData<Model: Decodable>(method: HTTPMethods,
                                     baseURl: URLCenter,
                                     path: String,
                                     model: Model.Type,
                                     completion: @escaping (Result<Model, Error>) -> Void) {
        
        let urlString = baseURl.buildURL(withPath: path)
        print("API URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            // completion(.failure(Error))
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Check for network availability. And if there is a network error, you return the error.
        /**
         completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No network found. Please check your settings"])))
         */
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
            
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    print("JSON Response: \(json)")
                } else {
                    print("Unable to convert data to JSON object")
                }
                
                let apiData = try JSONDecoder().decode(Model.self, from: data)
                print("Response JSON: \(apiData)")
                completion(.success(apiData))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
