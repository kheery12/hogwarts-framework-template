import Foundation
import UserNotifications
import UIKit

final class NotificationService {

    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Permission

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            Logger.log("Notification permission error: \(error)", level: .error)
            return false
        }
    }

    func checkPermissionStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    // MARK: - Daily Reminder

    func scheduleDailyReminder(at hour: Int = 8, minute: Int = 0) {
        // Remove existing
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        // Create content
        let content = UNMutableNotificationContent()
        content.title = "Today in History"
        content.body = "5 new historical facts are waiting for you!"
        content.sound = .default
        content.badge = 1

        // Schedule daily at specified time
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "daily-reminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                Logger.log("Failed to schedule notification: \(error)", level: .error)
            }
        }
    }

    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
    }

    // MARK: - Badge Management

    func clearBadge() async {
        if #available(iOS 16.0, *) {
            do {
                try await center.setBadgeCount(0)
            } catch {
                Logger.log("Failed to clear badge: \(error)", level: .error)
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

// MARK: - User Defaults Storage

extension NotificationService {
    private enum Keys {
        static let notificationsEnabled = "notificationsEnabled"
        static let reminderHour = "reminderHour"
        static let reminderMinute = "reminderMinute"
    }

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.notificationsEnabled) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.notificationsEnabled)
            if newValue {
                scheduleDailyReminder(at: reminderHour, minute: reminderMinute)
            } else {
                cancelDailyReminder()
            }
        }
    }

    var reminderHour: Int {
        get { UserDefaults.standard.integer(forKey: Keys.reminderHour).nonZeroOr(8) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.reminderHour)
            if isEnabled {
                scheduleDailyReminder(at: newValue, minute: reminderMinute)
            }
        }
    }

    var reminderMinute: Int {
        get { UserDefaults.standard.integer(forKey: Keys.reminderMinute) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.reminderMinute)
            if isEnabled {
                scheduleDailyReminder(at: reminderHour, minute: newValue)
            }
        }
    }
}

private extension Int {
    func nonZeroOr(_ defaultValue: Int) -> Int {
        self == 0 ? defaultValue : self
    }
}
