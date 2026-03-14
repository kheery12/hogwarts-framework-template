import UIKit
import BackgroundTasks
import Sentry

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // Initialize Sentry for crash monitoring
        SentrySDK.start { options in
            options.dsn = Config.sentryDSN
            options.tracesSampleRate = 0.2
            options.enableAutoSessionTracking = true
        }

        // Register background refresh task
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Config.backgroundRefreshIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundRefresh()
    }

    // MARK: - Background Refresh

    private func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Config.backgroundRefreshIdentifier)

        // Schedule for 6 AM local time
        var dateComponents = DateComponents()
        dateComponents.hour = 6
        dateComponents.minute = 0

        if let nextRefresh = Calendar.current.nextDate(
            after: Date(),
            matching: dateComponents,
            matchingPolicy: .nextTime
        ) {
            request.earliestBeginDate = nextRefresh
        }

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Logger.log("Failed to schedule background refresh: \(error)", level: .error)
        }
    }

    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        // Schedule the next refresh
        scheduleBackgroundRefresh()

        let operation = Task {
            do {
                let factService = FactService()
                let facts = try await factService.prefetchTodaysFacts()
                await PersistenceController.shared.cacheFacts(facts)
                task.setTaskCompleted(success: true)
            } catch {
                Logger.log("Background refresh failed: \(error)", level: .error)
                task.setTaskCompleted(success: false)
            }
        }

        task.expirationHandler = {
            operation.cancel()
        }
    }
}
