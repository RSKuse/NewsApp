//
//  URLCenter.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/01.
//

import Foundation

enum PlistKeys: String {
    case baseURL
    case apiKey
}

enum URLCenter {
    
    case newsUrl
    
    private var newsBaseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.baseURL.rawValue) as? String ?? ""
    }
    
    private var newsApiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: PlistKeys.apiKey.rawValue) as? String ?? ""
    }
    
    func buildURL(withPath path: String) -> String {
        
        switch self {
        case .newsUrl:
            return "\(newsBaseURL)/\(path)&apiKey=\(newsApiKey)"
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
