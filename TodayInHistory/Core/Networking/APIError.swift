import Foundation

enum APIError: LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case authenticationRequired
    case unauthorized
    case notFound
    case serverError(Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to process server response"
        case .authenticationRequired:
            return "Please sign in to continue"
        case .unauthorized:
            return "You don't have permission to do this"
        case .notFound:
            return "The requested content was not found"
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .unknown:
            return "An unexpected error occurred"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Check your internet connection and try again"
        case .authenticationRequired:
            return "Sign in with Apple or continue as guest"
        case .serverError:
            return "Our servers are experiencing issues. Please try again in a few minutes."
        default:
            return nil
        }
    }
}

enum FactError: LocalizedError {
    case noFactsAvailable
    case allFactsViewed

    var errorDescription: String? {
        switch self {
        case .noFactsAvailable:
            return "No facts available for today"
        case .allFactsViewed:
            return "You've seen all available facts for today"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noFactsAvailable, .allFactsViewed:
            return "New facts are generated daily at midnight UTC"
        }
    }
}
