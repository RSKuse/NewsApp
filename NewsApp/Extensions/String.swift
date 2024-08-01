//
//  Int.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/07/31.
//

import Foundation

extension String {
    
    func formattedRelativeDate() -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: self) else { return "" }
        
        let now = Date()
        let difference = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let days = difference.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = difference.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = difference.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else if let seconds = difference.second, seconds > 0 {
            return "\(seconds)s ago"
        } else {
            return "Just now"
        }
    }
}
