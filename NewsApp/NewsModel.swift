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

struct NewsModel: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Codable {
    var source: Source?
    var author, title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var likesCount: Int? = 0
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
