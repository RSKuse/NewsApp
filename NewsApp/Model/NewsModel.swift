//
//  NewsStructModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/07/30.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsApp = try? JSONDecoder().decode(NewsApp.self, from: jsonData)

import Foundation
import UIKit

struct NewsModel: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var likesCount: Int? = 0
    

    func getNewsSourceImage() -> UIImage? {
        guard let sourceId = source?.id else { return nil }
        
        switch sourceId {
        case "google-news":
            return UIImage(named: "google_news")
        case "space":
            return UIImage(named: "space_news")
        case "abc-new":
            return UIImage(named: "abc_news")
        case "bbc-news":
            return UIImage(named: "bbc_news")
        case "the-verge":
            return UIImage(named: "the_verge")
        case "techcrunch":
            return UIImage(named: "tech_crunch")
        case "Livescience.com":
            return UIImage(named: "live_science")
        default:
            return nil
        }
    }
}

struct Source: Codable {
    var id: String?
    var name: String?
}
enum ID: String, Codable {
    case googleNews = "google-news"
}

enum Name: String, Codable {
    case cnbc = "CNBC"
    case googleNews = "Google News"
    case theblockCo = "Theblock.co"
}

struct CategoryColors {
    static let colors: [NewsCategories: UIColor] = [
        .business: UIColor(red: 0.29, green: 0.69, blue: 0.87, alpha: 1.00), // Light Blue
        .sports: UIColor(red: 0.94, green: 0.76, blue: 0.20, alpha: 1.00),   // Gold
        .politics: UIColor(red: 0.76, green: 0.18, blue: 0.29, alpha: 1.00), // Red
        .technology: UIColor(red: 0.38, green: 0.31, blue: 0.86, alpha: 1.00), // Purple
        .health: UIColor(red: 0.47, green: 0.77, blue: 0.23, alpha: 1.00),   // Green
        .science: UIColor(red: 0.13, green: 0.67, blue: 0.47, alpha: 1.00),  // Teal
        .entertainment: UIColor(red: 0.91, green: 0.29, blue: 0.55, alpha: 1.00), // Pink
        .general: UIColor(red: 0.48, green: 0.51, blue: 0.55, alpha: 1.00)   // Gray
    ]
    
    static func color(for category: NewsCategories) -> UIColor {
        return colors[category] ?? .systemGray // Fallback color
    }
}
