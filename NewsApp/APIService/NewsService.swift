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
        guard let url = URL(string: urlString) else {
            // completion(.failure(Error))
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
                
                let apiData = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(apiData))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchWeatherData(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherAPIKey.rawValue) as? String ?? ""
        let baseURL = Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherBaseURL.rawValue) as? String ?? ""
        
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
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
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weatherModel))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherAPIKey.rawValue) as? String ?? ""
        let baseURL = Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherBaseURL.rawValue) as? String ?? ""
        
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
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
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weatherModel))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
