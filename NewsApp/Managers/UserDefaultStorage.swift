//
//  UserDefaultStorage.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/06.
//

import Foundation

// Fascade Pattern
final class UserDefaultsManager {
    
    // Singleton Pattern
    static let shared = UserDefaultsManager()
    
    enum UserDefaultKeys: String {
        case country
        case profileImage
        case userProfile
    }
    
    func storeValue(_ value: Any, key: UserDefaultKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func fetchValue(withKey key: UserDefaultKeys) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Any

    }
    
}
