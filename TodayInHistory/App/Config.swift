import Foundation

/// App configuration - Replace placeholder values before building
enum Config {

    // MARK: - Supabase
    static let supabaseURL = URL(string: "https://ewjpdmuloojbxypqscqp.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3anBkbXVsb29qYnh5cHFzY3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEzODYxNzQsImV4cCI6MjA4Njk2MjE3NH0.nZYIW7qWGDAHGWXMJg5FXSqT3AjjovkwqzoVcEisuho"

    // MARK: - Sentry
    // TODO: Replace with your Sentry DSN
    static let sentryDSN = "https://YOUR_SENTRY_DSN@sentry.io/PROJECT_ID"

    // MARK: - Background Tasks
    static let backgroundRefreshIdentifier = "com.todayinhistory.refresh"

    // MARK: - Admin
    static let adminTelegramEnabled = true

    // MARK: - API
    enum API {
        static let requestTimeout: TimeInterval = 30
        static let dailyFactsCount = 5  // One per region
        static let setsPerRegion = 3
        static let cacheDurationDays = 7
    }
}
