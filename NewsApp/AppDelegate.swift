//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2023/07/11.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: NewsViewController())
        application.statusBarStyle = .lightContent
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Request Notification Authorization
        requestNotificationAuthorization()

        return true
    }

    // Request Notification Authorization
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                self.scheduleDailyNotifications()
            } else if let error = error {
                print("Notification permission denied: \(error.localizedDescription)")
            }
        }
    }

    // Schedule daily notifications at 8 AM and 6 PM
    private func scheduleDailyNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()

        // Remove previously scheduled notifications to avoid duplicates
        notificationCenter.removeAllPendingNotificationRequests()

        // Schedule notifications
        let times = ["08:00", "18:00"]
        for time in times {
            let content = UNMutableNotificationContent()
            content.title = "Daily News Update"
            content.body = "Check out the latest news now!"
            content.sound = .default

            // Set the trigger time
            let dateComponents = getDateComponents(for: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "news_notification_\(time)", content: content, trigger: trigger)

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    }

    // Helper function to get DateComponents for scheduling
    private func getDateComponents(for time: String) -> DateComponents {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else {
            fatalError("Invalid time format")
        }

        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
}
