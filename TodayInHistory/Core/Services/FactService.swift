import Foundation

@MainActor
final class FactService: ObservableObject {

    @Published var todaysFacts: [Fact] = []
    @Published var isLoading = false
    @Published var isExhausted = false
    @Published var error: Error?

    private let supabase = SupabaseClient.shared
    private let persistence = PersistenceController.shared

    // MARK: - Fetch Daily Facts

    func fetchDailyFacts(for date: Date) async throws {
        isLoading = true
        isExhausted = false
        error = nil
        defer { isLoading = false }

        let dateString = formatDateForQuery(date)

        var facts: [Fact] = []

        for region in Region.allCases {
            if let fact = try await getBestFactForRegion(
                region: region,
                date: dateString
            ) {
                facts.append(fact)
            }
        }

        if facts.isEmpty {
            isExhausted = true
        }

        todaysFacts = facts

        // Cache locally for offline access
        await persistence.cacheFacts(facts)
    }

    // MARK: - Fetch Today's Facts (with user view tracking)

    func fetchTodaysFacts(for user: User) async throws {
        isLoading = true
        isExhausted = false
        error = nil
        defer { isLoading = false }

        let today = formatDateForQuery(Date())

        // Get user's viewed facts for today
        let viewedFactIds = try await getViewedFactIds(userId: user.id, date: today)

        var facts: [Fact] = []

        for region in Region.allCases {
            if let fact = try await getBestFactForRegion(
                region: region,
                date: today,
                excludeIds: viewedFactIds
            ) {
                facts.append(fact)
                // Mark as viewed
                try await markFactViewed(userId: user.id, factId: fact.id)
            }
        }

        if facts.isEmpty && !viewedFactIds.isEmpty {
            isExhausted = true
        }

        todaysFacts = facts

        // Cache locally for offline access
        await persistence.cacheFacts(facts)
    }

    // MARK: - Fetch Fact Detail

    func fetchFactDetail(factId: UUID) async throws -> Fact {
        let fact: Fact = try await supabase
            .from(SupabaseClient.Table.dailyFacts)
            .select()
            .eq("id", value: factId)
            .eq("review_status", value: "approved")
            .single()
            .execute()
            .value

        return fact
    }

    // MARK: - Fetch Today's Fact for a Specific Region

    func fetchTodayFact(for region: Region) async throws -> Fact? {
        let today = formatDateForQuery(Date())

        let facts: [Fact] = try await supabase
            .from(SupabaseClient.Table.dailyFacts)
            .select()
            .eq("date", value: today)
            .eq("region", value: region.rawValue)
            .eq("review_status", value: "approved")
            .order("set_number")
            .limit(1)
            .execute()
            .value

        return facts.first
    }

    // MARK: - Fetch World Context

    func fetchWorldContext(for factId: UUID) async throws -> [WorldContext] {
        let contexts: [WorldContext] = try await supabase
            .from(SupabaseClient.Table.worldContext)
            .select()
            .eq("fact_id", value: factId.uuidString)
            .order("context_region")
            .execute()
            .value

        return contexts.sorted { $0.contextRegion.displayName < $1.contextRegion.displayName }
    }

    // MARK: - Prefetch (Background)

    func prefetchTodaysFacts() async throws -> [Fact] {
        let today = formatDateForQuery(Date())

        let facts: [Fact] = try await supabase
            .from(SupabaseClient.Table.dailyFacts)
            .select()
            .eq("date", value: today)
            .eq("review_status", value: "approved")
            .order("region")
            .order("set_number")
            .execute()
            .value

        return facts
    }

    // MARK: - Offline Fallback

    func loadCachedFacts(for date: Date) -> [Fact] {
        persistence.getCachedFacts(for: date)
    }

    // MARK: - Private Helpers

    private func getBestFactForRegion(
        region: Region,
        date: String,
        excludeIds: [UUID] = []
    ) async throws -> Fact? {

        var facts: [Fact] = try await supabase
            .from(SupabaseClient.Table.dailyFacts)
            .select()
            .eq("date", value: date)
            .eq("region", value: region.rawValue)
            .eq("review_status", value: "approved")
            .execute()
            .value

        // Filter out already viewed facts
        if !excludeIds.isEmpty {
            facts = facts.filter { !excludeIds.contains($0.id) }
        }

        guard !facts.isEmpty else { return nil }

        // Return lowest set number available
        return facts.sorted { $0.setNumber < $1.setNumber }.first
    }

    private func getViewedFactIds(userId: UUID, date: String) async throws -> [UUID] {
        struct ViewRow: Codable {
            let factId: UUID

            enum CodingKeys: String, CodingKey {
                case factId = "fact_id"
            }
        }

        // Join with daily_facts to filter by date
        let views: [ViewRow] = try await supabase
            .from(SupabaseClient.Table.userFactViews)
            .select("fact_id, daily_facts!inner(date)")
            .eq("user_id", value: userId)
            .eq("daily_facts.date", value: date)
            .execute()
            .value

        return views.map { $0.factId }
    }

    private func markFactViewed(userId: UUID, factId: UUID) async throws {
        let viewData: [String: AnyJSON] = [
            "user_id": .string(userId.uuidString),
            "fact_id": .string(factId.uuidString)
        ]

        try await supabase
            .from(SupabaseClient.Table.userFactViews)
            .upsert(viewData)
            .execute()
    }

    private func formatDateForQuery(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
}
