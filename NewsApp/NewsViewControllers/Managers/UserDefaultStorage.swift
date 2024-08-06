//
//  UserDefaultStorage.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/06.
//

import Foundation

enum UserDefaultStorage {
    case country
    
    func storeValue(_ value: String) {
        switch self {
        case .country:
            UserDefaults.standard.set(value, forKey: "country")
            
        }
    }
    
    func fetchValue() -> String? {
        return UserDefaults.standard.value(forKey: "country") as? String
    }
    
}
