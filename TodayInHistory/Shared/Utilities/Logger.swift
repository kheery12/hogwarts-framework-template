import Foundation
import os.log

enum Logger {

    enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }

    private static let osLog = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "TodayInHistory",
        category: "General"
    )

    static func log(
        _ message: String,
        level: Level = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent

        #if DEBUG
        let fullMessage = "[\(level.rawValue)] [\(fileName):\(line)] \(function) - \(message)"
        print(fullMessage)
        #endif

        // Also log to OSLog for production debugging
        let osLogType: OSLogType = {
            switch level {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }()

        os_log("%{public}@", log: osLog, type: osLogType, message)
    }
}
