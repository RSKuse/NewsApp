//
//  WeatherModel.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/09/31.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: String?

    enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, wind, clouds, dt, sys, timezone, id, name, cod
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try container.decodeIfPresent(Coord.self, forKey: .coord)
        weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        base = try container.decodeIfPresent(String.self, forKey: .base)
        main = try container.decodeIfPresent(Main.self, forKey: .main)
        visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
        dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        // Handle cod being either an Int or String
        if let codInt = try? container.decode(Int.self, forKey: .cod) {
            cod = String(codInt)
        } else {
            cod = try container.decodeIfPresent(String.self, forKey: .cod)
        }
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    var lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    var type, id: Int?
    var country: String?
    var sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}
