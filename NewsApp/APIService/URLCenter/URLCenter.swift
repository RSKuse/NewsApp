//
//  URLCenter.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

enum PlistKeys: String {
    case newsBaseURL
    case weatherBaseURL
    case newsApiKey
    case weatherAPIKey

}

enum URLCenter {
    
    case newsUrl
    case weatherURL
    
    /**
     - News API Information
     */
    private var newsBaseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.newsBaseURL.rawValue) as? String ?? ""
    }
    
    private var newsApiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.newsApiKey.rawValue) as? String ?? ""
    }
    
    /**
     - Weather API Information
     */
    private var weatherBaseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherBaseURL.rawValue) as? String ?? ""
    }
    
    private var weatherApiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.weatherAPIKey.rawValue) as? String ?? ""
    }
    
    func buildURL(withPath path: String) -> String {
        
        switch self {
        case .newsUrl:
            let url = "\(newsBaseURL)/\(path)&apiKey=\(newsApiKey)"
            print(url)
            return url
        case .weatherURL:
            // lat=34.2232&long=93.54834
            return "\(weatherBaseURL)?\(path)&appid=\(weatherApiKey)"
            
            
        }
    }
}

/*
class URLCenter {
    
    enum PlistKeys: String {
        case baseURL
        case apiKey
    }
    
    // BaseURL
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.baseURL.rawValue) as? String ?? ""
    }
    
    static var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.apiKey.rawValue) as? String ?? ""
    }
    
    static func buildNewsURL(newType: NewsType = .topHeadlines,
                             country: NewsCountry = .za,
                             category: NewCategories = .politics) -> String {
        return "\(baseURL)/\(newType)?country=\(country)&category=\(category)&apiKey=\(apiKey)"
    }
}
*/
