import Foundation
import Supabase

/// Singleton Supabase client for database and auth operations
final class SupabaseClient {

    static let shared = SupabaseClient()

    let client: Supabase.SupabaseClient

    private init() {
        client = Supabase.SupabaseClient(
            supabaseURL: Config.supabaseURL,
            supabaseKey: Config.supabaseAnonKey
        )
    }

    // MARK: - Auth Convenience

    var auth: AuthClient {
        client.auth
    }

    // MARK: - Database Convenience

    func from(_ table: String) -> PostgrestQueryBuilder {
        client.from(table)
    }

    // MARK: - Functions Convenience

    var functions: FunctionsClient {
        client.functions
    }
}

// MARK: - Table Names

extension SupabaseClient {
    enum Table {
        static let users = "users"
        static let dailyFacts = "daily_facts"
        static let favorites = "favorites"
        static let userPreferences = "user_preferences"
        static let userFactViews = "user_fact_views"
        static let worldContext = "world_context"
    }
}
