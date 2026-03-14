# Today In History - Implementation Plan v2.0

> **Status**: ✅ APPROVED BY HEADMASTER
> **Created**: 2026-02-17
> **Reviewed By**: Professor Council (Flitwick, McGonagall, Snape, Sprout)
> **Mission**: Build an iOS app delivering daily curated historical facts from 5 world regions

---

## Executive Summary

A native iOS app (iOS 15+) using SwiftUI, Supabase, and Wikipedia API to deliver 5 daily historical facts from major world regions. Server-side fact generation via Supabase Edge Functions stores 3 sets daily (15 facts) to support Pro regeneration. Free tier with limited regenerations, Pro tier with topic preferences and extended regenerations via StoreKit 2.

---

## Technical Decisions (Locked)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| iOS Minimum | **15.0** | Async/await support, ~95% device coverage, iPhone 6s+ |
| UI Framework | **SwiftUI** | Modern, declarative, maintainable |
| State Management | **ObservableObject** | Uniform approach for iOS 15-16-17 compatibility |
| Backend | **Supabase** | Auth + DB + Edge Functions + Realtime in one |
| Image Caching | **Kingfisher** | Battle-tested, handles Wikipedia images well |
| Subscriptions | **StoreKit 2** | Modern API, cleaner than SK1 |
| Local Storage | **CoreData** | Native iOS, offline support |
| Crash Monitoring | **Sentry** | Industry standard, good Swift support |
| Content Source | **Wikipedia API** | Free, comprehensive, global coverage |

---

## Data Architecture

### Daily Fact Storage Model

**The Math:**
- 5 regions × 3 sets per day = **15 facts stored daily**
- Each fact tagged with ONE topic
- Edge Function generates variety across topics

### Database Schema (Supabase)

```sql
-- Users table (extends Supabase auth)
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users,
  display_name TEXT,
  is_pro BOOLEAN DEFAULT FALSE,
  regenerations_today INTEGER DEFAULT 0,
  last_regeneration_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User preferences (Pro feature)
CREATE TABLE user_preferences (
  user_id UUID REFERENCES users ON DELETE CASCADE,
  topic TEXT CHECK (topic IN (
    'sports', 'history', 'politics', 'entertainment',
    'science', 'technology', 'social_movements', 'military'
  )),
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (user_id, topic)
);

-- Daily facts (generated server-side)
CREATE TABLE daily_facts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date DATE NOT NULL,
  region TEXT NOT NULL CHECK (region IN (
    'north_america', 'europe', 'asia', 'africa', 'south_america'
  )),
  set_number INTEGER NOT NULL CHECK (set_number BETWEEN 1 AND 3),
  topic TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT NOT NULL,        -- 2-3 sentences
  full_content TEXT NOT NULL,   -- 400-600 words
  image_url TEXT,
  source_url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE (date, region, set_number)
);

-- User favorites
CREATE TABLE favorites (
  user_id UUID REFERENCES users ON DELETE CASCADE,
  fact_id UUID REFERENCES daily_facts ON DELETE CASCADE,
  saved_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, fact_id)
);

-- User fact views (track which sets they've seen today)
CREATE TABLE user_fact_views (
  user_id UUID REFERENCES users ON DELETE CASCADE,
  fact_id UUID REFERENCES daily_facts ON DELETE CASCADE,
  viewed_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, fact_id)
);

-- Indexes
CREATE INDEX idx_daily_facts_date ON daily_facts(date);
CREATE INDEX idx_daily_facts_date_region ON daily_facts(date, region);
CREATE INDEX idx_favorites_user ON favorites(user_id);
```

### Row Level Security (RLS)

```sql
-- Users can only read/update their own data
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users update own data" ON users FOR UPDATE USING (auth.uid() = id);

-- Daily facts are public read
ALTER TABLE daily_facts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read facts" ON daily_facts FOR SELECT USING (true);

-- Favorites are private
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own favorites" ON favorites
  FOR ALL USING (auth.uid() = user_id);

-- Preferences are private
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own preferences" ON user_preferences
  FOR ALL USING (auth.uid() = user_id);
```

### Preference Routing Logic

**Soft preference matching** - preferences PRIORITIZE but don't exclude:

```
For each region:
  1. Get user's enabled topic preferences
  2. Find facts for today matching ANY preference
  3. Exclude already-viewed facts
  4. If match found → serve that fact
  5. If no match → serve lowest set_number not yet viewed
  6. If all viewed → return "exhausted" status
```

**Result**: Pro users always get 5 facts (one per region), topic-relevant where possible.

---

## Phase 1: Foundation (Year 3)

### 1.1 Project Setup
- [ ] Create Xcode project with SwiftUI App lifecycle
- [ ] Configure for iOS 15.0 minimum deployment target
- [ ] Set up Swift Package Manager dependencies:
  ```swift
  // Package.swift dependencies
  .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0"),
  .package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0"),
  .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.0.0")
  ```
- [ ] Configure app capabilities in Xcode:
  - Sign in with Apple
  - Background Fetch
  - Push Notifications
- [ ] Create `Config.swift` for environment configuration:
  ```swift
  enum Config {
      static let supabaseURL = URL(string: "https://xxx.supabase.co")!
      static let supabaseAnonKey = "your-anon-key"

      enum StoreKit {
          static let proMonthly = "com.todayinhistory.pro.monthly"
          static let proYearly = "com.todayinhistory.pro.yearly"
      }
  }
  ```

### 1.2 Project Structure
```
TodayInHistory/
├── App/
│   ├── TodayInHistoryApp.swift
│   └── AppDelegate.swift (for Sentry init)
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   │       ├── FactCard.swift
│   │       └── RegionHeader.swift
│   ├── FactDetail/
│   │   ├── FactDetailView.swift
│   │   └── FactDetailViewModel.swift
│   ├── Favorites/
│   │   ├── FavoritesView.swift
│   │   └── FavoritesViewModel.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── ProfileViewModel.swift
│   │   └── Components/
│   │       ├── PreferencesGrid.swift
│   │       └── SubscriptionCard.swift
│   └── Onboarding/
│       ├── OnboardingView.swift
│       └── OnboardingPage.swift
├── Core/
│   ├── Models/
│   │   ├── Fact.swift
│   │   ├── User.swift
│   │   ├── Region.swift
│   │   └── Topic.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   ├── FactService.swift
│   │   ├── SubscriptionService.swift
│   │   └── NotificationService.swift
│   ├── Networking/
│   │   ├── SupabaseClient.swift
│   │   └── APIError.swift
│   └── Persistence/
│       ├── PersistenceController.swift
│       └── TodayInHistory.xcdatamodeld
├── Shared/
│   ├── Extensions/
│   │   ├── Date+Extensions.swift
│   │   └── View+Extensions.swift
│   └── Utilities/
│       └── Logger.swift
├── UI/
│   ├── Components/
│   │   ├── RegionBadge.swift
│   │   ├── TopicChip.swift
│   │   ├── ProBadge.swift
│   │   ├── LoadingView.swift
│   │   └── ErrorView.swift
│   └── Theme/
│       ├── Colors.swift
│       ├── Typography.swift
│       └── Spacing.swift
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings
│   └── RegionPlaceholders/ (fallback images)
└── Tests/
    ├── UnitTests/
    │   ├── FactServiceTests.swift
    │   ├── AuthServiceTests.swift
    │   └── PreferenceRoutingTests.swift
    ├── IntegrationTests/
    │   └── SupabaseSyncTests.swift
    └── UITests/
        ├── OnboardingFlowTests.swift
        └── PurchaseFlowTests.swift
```

### 1.3 Supabase Configuration
- [ ] Create Supabase project
- [ ] Run database schema SQL (above)
- [ ] Enable Sign in with Apple provider
- [ ] Configure RLS policies
- [ ] Set up pg_cron for daily fact generation:
  ```sql
  SELECT cron.schedule(
    'generate-daily-facts',
    '0 0 * * *',  -- Midnight UTC daily
    $$SELECT net.http_post(
      url := 'https://xxx.supabase.co/functions/v1/generate-facts',
      headers := '{"Authorization": "Bearer service_role_key"}'
    )$$
  );
  ```

---

## Phase 2: Core Services (Year 3)

### 2.1 Supabase Edge Function: Fact Generation

**File**: `supabase/functions/generate-facts/index.ts`

```typescript
// Runs daily at midnight UTC via pg_cron
// Generates 15 facts: 5 regions × 3 sets

import { createClient } from '@supabase/supabase-js'

const REGIONS = ['north_america', 'europe', 'asia', 'africa', 'south_america']
const TOPICS = ['sports', 'history', 'politics', 'entertainment',
                'science', 'technology', 'social_movements', 'military']

Deno.serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const today = new Date().toISOString().split('T')[0]
  const facts = []

  for (const region of REGIONS) {
    const usedTopics: string[] = []

    for (let setNum = 1; setNum <= 3; setNum++) {
      // Fetch from Wikipedia "On This Day"
      const fact = await fetchWikipediaFact(region, usedTopics)
      usedTopics.push(fact.topic)

      facts.push({
        date: today,
        region,
        set_number: setNum,
        topic: fact.topic,
        title: fact.title,
        summary: fact.summary,
        full_content: fact.content,
        image_url: fact.imageUrl,
        source_url: fact.sourceUrl
      })
    }
  }

  const { error } = await supabase
    .from('daily_facts')
    .upsert(facts, { onConflict: 'date,region,set_number' })

  return new Response(JSON.stringify({ success: !error, count: facts.length }))
})
```

### 2.2 Authentication Service

```swift
// Core/Services/AuthService.swift

import AuthenticationServices
import Supabase

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isGuest = false

    private let supabase = SupabaseClient.shared

    // Sign in with Apple
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        let idToken = String(data: credential.identityToken!, encoding: .utf8)!

        try await supabase.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idToken)
        )

        await loadCurrentUser()
    }

    // Continue as Guest (anonymous auth)
    func continueAsGuest() async throws {
        try await supabase.auth.signInAnonymously()
        isGuest = true
        await loadCurrentUser()
    }

    // Upgrade Guest to Apple ID (account linking)
    func linkAppleAccount(credential: ASAuthorizationAppleIDCredential) async throws {
        // Preserve existing favorites before linking
        let existingFavorites = try await fetchFavorites()

        let idToken = String(data: credential.identityToken!, encoding: .utf8)!
        try await supabase.auth.linkIdentity(
            credentials: .init(provider: .apple, idToken: idToken)
        )

        // Restore favorites to linked account
        try await restoreFavorites(existingFavorites)

        isGuest = false
        await loadCurrentUser()
    }

    func signOut() async throws {
        try await supabase.auth.signOut()
        currentUser = nil
        isAuthenticated = false
        isGuest = false
    }
}
```

### 2.3 Fact Service with Preference Routing

```swift
// Core/Services/FactService.swift

@MainActor
class FactService: ObservableObject {
    @Published var todaysFacts: [Fact] = []
    @Published var isLoading = false
    @Published var isExhausted = false

    private let supabase = SupabaseClient.shared

    func fetchTodaysFacts(for user: User) async throws {
        isLoading = true
        defer { isLoading = false }

        let today = Date().formatted(.iso8601.year().month().day())

        // Get user's viewed facts for today
        let viewedFactIds = try await getViewedFactIds(userId: user.id, date: today)

        // Get user's topic preferences (Pro only)
        let preferences = user.isPro ? try await getPreferences(userId: user.id) : nil

        var facts: [Fact] = []

        for region in Region.allCases {
            if let fact = try await getBestFactForRegion(
                region: region,
                date: today,
                preferences: preferences,
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
    }

    func regenerate(for user: User) async throws {
        guard canRegenerate(user: user) else {
            throw FactError.regenerationLimitReached
        }

        try await incrementRegenerationCount(userId: user.id)
        try await fetchTodaysFacts(for: user)
    }

    private func getBestFactForRegion(
        region: Region,
        date: String,
        preferences: [Topic]?,
        excludeIds: [UUID]
    ) async throws -> Fact? {

        // Query facts for this region today, excluding viewed
        var query = supabase
            .from("daily_facts")
            .select()
            .eq("date", value: date)
            .eq("region", value: region.rawValue)

        if !excludeIds.isEmpty {
            query = query.not("id", operator: .in, value: excludeIds)
        }

        let facts: [Fact] = try await query.execute().value

        guard !facts.isEmpty else { return nil }

        // If Pro with preferences, prioritize matching topics
        if let prefs = preferences, !prefs.isEmpty {
            let prefStrings = prefs.map { $0.rawValue }
            if let match = facts.first(where: { prefStrings.contains($0.topic) }) {
                return match
            }
        }

        // Fallback: return lowest set number available
        return facts.sorted { $0.setNumber < $1.setNumber }.first
    }
}
```

### 2.4 Subscription Service with Server-Side Validation

```swift
// Core/Services/SubscriptionService.swift

import StoreKit

@MainActor
class SubscriptionService: ObservableObject {
    @Published var isPro = false
    @Published var products: [Product] = []

    private let supabase = SupabaseClient.shared

    func loadProducts() async {
        do {
            products = try await Product.products(for: [
                Config.StoreKit.proMonthly,
                Config.StoreKit.proYearly
            ])
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            // Validate server-side via Edge Function
            try await validateReceiptServerSide(transaction)

            await transaction.finish()
            isPro = true

        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }

    private func validateReceiptServerSide(_ transaction: Transaction) async throws {
        // Call Supabase Edge Function to validate with Apple
        let response = try await supabase.functions.invoke(
            "validate-receipt",
            options: .init(body: [
                "transactionId": transaction.id,
                "originalTransactionId": transaction.originalID
            ])
        )

        guard let data = response.data,
              let result = try? JSONDecoder().decode(ValidationResult.self, from: data),
              result.valid else {
            throw SubscriptionError.validationFailed
        }
    }

    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == Config.StoreKit.proMonthly ||
                   transaction.productID == Config.StoreKit.proYearly {
                    isPro = true
                    return
                }
            }
        }
        isPro = false
    }
}
```

### 2.5 Local Persistence (CoreData)

```swift
// Core/Persistence/PersistenceController.swift

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TodayInHistory")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Cache facts locally for offline access
    func cacheFacts(_ facts: [Fact]) async {
        let context = container.newBackgroundContext()

        await context.perform {
            for fact in facts {
                let cached = CachedFact(context: context)
                cached.id = fact.id
                cached.date = fact.date
                cached.region = fact.region.rawValue
                cached.title = fact.title
                cached.summary = fact.summary
                cached.fullContent = fact.fullContent
                cached.imageURL = fact.imageUrl
                cached.sourceURL = fact.sourceUrl
                cached.cachedAt = Date()
            }

            try? context.save()
        }
    }

    // Retrieve cached facts (offline mode)
    func getCachedFacts(for date: Date) -> [Fact] {
        let request: NSFetchRequest<CachedFact> = CachedFact.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)

        guard let cached = try? container.viewContext.fetch(request) else {
            return []
        }

        return cached.map { $0.toFact() }
    }

    // Clean up old cached facts (keep 7 days)
    func pruneOldCache() async {
        let context = container.newBackgroundContext()
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

        await context.perform {
            let request: NSFetchRequest<NSFetchRequestResult> = CachedFact.fetchRequest()
            request.predicate = NSPredicate(format: "cachedAt < %@", cutoff as NSDate)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try? context.execute(deleteRequest)
        }
    }
}
```

---

## Phase 3: User Interface (Year 3)

### 3.1 Design System

```swift
// UI/Theme/Colors.swift
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let background = Color("Background")
    let cardBackground = Color("CardBackground")
    let primaryText = Color("PrimaryText")
    let secondaryText = Color("SecondaryText")
    let accent = Color("Accent")
    let proGold = Color("ProGold")

    // Region colors
    let northAmerica = Color("NorthAmerica")
    let europe = Color("Europe")
    let asia = Color("Asia")
    let africa = Color("Africa")
    let southAmerica = Color("SouthAmerica")
}

// UI/Theme/Typography.swift
extension Font {
    static let factTitle = Font.system(.title2, design: .serif, weight: .semibold)
    static let factBody = Font.system(.body, design: .serif)
    static let cardSubtitle = Font.system(.subheadline, design: .default)
    static let badge = Font.system(.caption, design: .default, weight: .medium)
}
```

### 3.2 Core Components

```swift
// UI/Components/FactCard.swift

struct FactCard: View {
    let fact: Fact
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Region badge
            RegionBadge(region: fact.region)

            // Image with Kingfisher
            KFImage(URL(string: fact.imageUrl ?? ""))
                .placeholder { RegionPlaceholder(region: fact.region) }
                .resizable()
                .aspectRatio(16/9, contentMode: .fill)
                .cornerRadius(12)

            // Title
            Text(fact.title)
                .font(.factTitle)
                .foregroundColor(.theme.primaryText)
                .lineLimit(2)

            // Summary
            Text(fact.summary)
                .font(.factBody)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(3)

            // Topic chip
            TopicChip(topic: fact.topic)
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .onTapGesture(perform: onTap)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fact.region.displayName) fact: \(fact.title)")
        .accessibilityHint("Double tap to read full article")
    }
}

// UI/Components/RegionBadge.swift

struct RegionBadge: View {
    let region: Region

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: region.iconName)
            Text(region.displayName)
        }
        .font(.badge)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(region.color.opacity(0.15))
        .foregroundColor(region.color)
        .cornerRadius(8)
    }
}
```

### 3.3 Image Fallback Chain

```swift
// Three-tier fallback for images
struct FactImage: View {
    let fact: Fact

    var body: some View {
        KFImage(URL(string: fact.imageUrl ?? ""))
            .onFailure { _ in
                // Tier 2: Try Wikimedia Commons
            }
            .placeholder {
                // Tier 3: Region-specific placeholder
                RegionPlaceholder(region: fact.region)
            }
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
    }
}

struct RegionPlaceholder: View {
    let region: Region

    var body: some View {
        ZStack {
            region.color.opacity(0.2)
            Image(region.placeholderImageName)
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(region.color.opacity(0.5))
        }
    }
}
```

### 3.4 Screen Implementations

#### Home Screen
```swift
// Features/Home/HomeView.swift

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.facts) { fact in
                        NavigationLink(value: fact) {
                            FactCard(
                                fact: fact,
                                onTap: {},
                                onFavorite: { viewModel.toggleFavorite(fact) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Today in History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    RegenerateButton(
                        remaining: viewModel.regenerationsRemaining,
                        isPro: authService.currentUser?.isPro ?? false
                    ) {
                        Task { await viewModel.regenerate() }
                    }
                }
            }
            .navigationDestination(for: Fact.self) { fact in
                FactDetailView(fact: fact)
            }
            .overlay {
                if viewModel.isExhausted {
                    ExhaustedView()
                }
            }
        }
    }
}
```

#### Fact Detail Screen
```swift
// Features/FactDetail/FactDetailView.swift

struct FactDetailView: View {
    let fact: Fact
    @StateObject private var viewModel: FactDetailViewModel
    @State private var showSafariConfirm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero image
                FactImage(fact: fact)
                    .frame(height: 250)
                    .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    // Region and topic
                    HStack {
                        RegionBadge(region: fact.region)
                        TopicChip(topic: fact.topic)
                        Spacer()
                    }

                    // Title
                    Text(fact.title)
                        .font(.title)
                        .fontDesign(.serif)

                    // Full content
                    Text(fact.fullContent)
                        .font(.factBody)
                        .lineSpacing(6)

                    // Read more button
                    Button {
                        showSafariConfirm = true
                    } label: {
                        Label("Read Full Article", systemImage: "safari")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ShareLink(item: fact.shareText)

                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                }
            }
        }
        .confirmationDialog(
            "Open in Safari?",
            isPresented: $showSafariConfirm
        ) {
            Link("Open Article", destination: URL(string: fact.sourceUrl)!)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will open the full Wikipedia article in Safari.")
        }
    }
}
```

#### Favorites Screen
```swift
// Features/Favorites/FavoritesView.swift

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favorites.isEmpty {
                    EmptyFavoritesView()
                } else {
                    List {
                        ForEach(viewModel.favorites) { fact in
                            NavigationLink(value: fact) {
                                FavoriteRow(fact: fact)
                            }
                        }
                        .onDelete(perform: viewModel.removeFavorites)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Fact.self) { fact in
                FactDetailView(fact: fact)
            }
        }
    }
}
```

#### Profile Screen
```swift
// Features/Profile/ProfileView.swift

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var subscriptionService: SubscriptionService
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            List {
                // User info section
                Section {
                    UserHeaderView(user: authService.currentUser)
                }

                // Subscription section
                Section("Subscription") {
                    if subscriptionService.isPro {
                        ProStatusView()
                    } else {
                        UpgradeProCard {
                            viewModel.showPaywall = true
                        }
                    }
                }

                // Preferences section (Pro only)
                Section("Topic Preferences") {
                    if subscriptionService.isPro {
                        PreferencesGrid(
                            preferences: $viewModel.preferences,
                            onChange: viewModel.savePreferences
                        )
                    } else {
                        LockedPreferencesView()
                    }
                }

                // Settings section
                Section("Settings") {
                    NotificationToggle()
                    AppearanceSelector()
                    Link("Privacy Policy", destination: URL(string: "...")!)
                    Link("Terms of Service", destination: URL(string: "...")!)
                }

                // Account actions
                Section {
                    if authService.isGuest {
                        Button("Sign in with Apple") {
                            viewModel.showAppleSignIn = true
                        }
                    }

                    Button("Sign Out", role: .destructive) {
                        Task { try? await authService.signOut() }
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.showPaywall) {
                PaywallView()
            }
        }
    }
}
```

#### Onboarding
```swift
// Features/Onboarding/OnboardingView.swift

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthService
    @State private var currentPage = 0

    let pages = [
        OnboardingPage(
            title: "Discover History",
            subtitle: "5 fascinating facts daily from around the world",
            imageName: "globe.americas.fill"
        ),
        OnboardingPage(
            title: "Explore Cultures",
            subtitle: "Stories from North America, Europe, Asia, Africa, and South America",
            imageName: "map.fill"
        ),
        OnboardingPage(
            title: "Go Pro",
            subtitle: "Customize topics and regenerate facts your way",
            imageName: "crown.fill"
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)

            VStack(spacing: 16) {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { result in
                    Task { try? await authService.handleAppleSignIn(result) }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)

                Button("Continue as Guest") {
                    Task { try? await authService.continueAsGuest() }
                }
                .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
```

---

## Phase 4: Background & Notifications (Year 5)

### 4.1 Background Fetch

```swift
// App/AppDelegate.swift

import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Sentry
        SentrySDK.start { options in
            options.dsn = "your-sentry-dsn"
            options.tracesSampleRate = 0.2
        }

        // Register background task
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.todayinhistory.refresh",
            using: nil
        ) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }

        return true
    }

    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.todayinhistory.refresh")
        request.earliestBeginDate = Calendar.current.date(
            bySettingHour: 6, minute: 0, second: 0, of: Date()
        )

        try? BGTaskScheduler.shared.submit(request)
    }

    func handleBackgroundRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundRefresh() // Schedule next

        let operation = Task {
            do {
                let facts = try await FactService().prefetchTodaysFacts()
                await PersistenceController.shared.cacheFacts(facts)
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }

        task.expirationHandler = {
            operation.cancel()
        }
    }
}
```

### 4.2 Notifications

```swift
// Core/Services/NotificationService.swift

import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(at hour: Int = 8, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()

        // Remove existing
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        // Create content
        let content = UNMutableNotificationContent()
        content.title = "Today in History"
        content.body = "5 new historical facts are waiting for you!"
        content.sound = .default

        // Schedule daily
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

        center.add(request)
    }

    func cancelDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
    }
}
```

---

## Phase 5: Polish & Accessibility (Year 3)

### 5.1 Accessibility Implementation

```swift
// All components include:
// - .accessibilityLabel() for VoiceOver
// - .accessibilityHint() for actions
// - Dynamic Type support via .font() system fonts
// - Sufficient color contrast (tested with Accessibility Inspector)

// Example: FactCard accessibility
.accessibilityElement(children: .combine)
.accessibilityLabel("\(fact.region.displayName): \(fact.title)")
.accessibilityHint("Double tap to read the full article about \(fact.title)")
.accessibilityAddTraits(.isButton)

// Reduce Motion support
@Environment(\.accessibilityReduceMotion) var reduceMotion

.animation(reduceMotion ? nil : .spring(), value: isExpanded)
```

### 5.2 Error States

```swift
// UI/Components/ErrorView.swift

struct ErrorView: View {
    let error: Error
    let retry: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Couldn't Load Facts")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await retry() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// Exhausted state
struct ExhaustedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text("You've Seen Everything!")
                .font(.headline)

            Text("Check back tomorrow for new historical discoveries.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
}
```

---

## Phase 6: Testing & Launch (Year 5)

### 6.1 Test Strategy

**Unit Tests (Target: 80% coverage on Services)**
```swift
// Tests/UnitTests/FactServiceTests.swift

final class FactServiceTests: XCTestCase {

    func testPreferenceRoutingPrioritizesMatchingTopics() async throws {
        // Given: User prefers Sports, History
        // And: Available facts include Sports fact in Set 2
        // When: Fetching facts
        // Then: Should return Set 2 for that region (Sports match)
    }

    func testPreferenceRoutingFallsBackToSet1() async throws {
        // Given: User prefers Topics not available today
        // When: Fetching facts
        // Then: Should return Set 1 for each region (fallback)
    }

    func testRegenerationLimitEnforced() async throws {
        // Given: Free user who has regenerated once
        // When: Attempting second regeneration
        // Then: Should throw regenerationLimitReached
    }
}

// Tests/UnitTests/AuthServiceTests.swift

final class AuthServiceTests: XCTestCase {

    func testGuestToAppleLinkingPreservesFavorites() async throws {
        // Given: Guest user with favorites
        // When: Linking Apple account
        // Then: Favorites should persist after linking
    }
}
```

**Integration Tests**
```swift
// Tests/IntegrationTests/SupabaseSyncTests.swift

final class SupabaseSyncTests: XCTestCase {

    func testFactsAreCachedLocally() async throws {
        // Given: Network fetch succeeds
        // When: Facts are loaded
        // Then: CoreData should contain cached copies
    }

    func testOfflineModeUsesCachedFacts() async throws {
        // Given: No network, cached facts exist
        // When: Loading facts
        // Then: Should return cached facts without error
    }
}
```

**UI Tests**
```swift
// Tests/UITests/OnboardingFlowTests.swift

final class OnboardingFlowTests: XCTestCase {

    func testGuestOnboardingFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // Swipe through onboarding
        app.swipeLeft()
        app.swipeLeft()

        // Tap continue as guest
        app.buttons["Continue as Guest"].tap()

        // Verify home screen appears
        XCTAssertTrue(app.navigationBars["Today in History"].exists)
    }
}
```

### 6.2 TestFlight Plan

- **Beta Testers**: 15-20 testers
- **Duration**: 2 weeks minimum
- **Feedback Focus**:
  - Content quality and relevance
  - Regional diversity
  - UI/UX issues
  - Performance on older devices (iPhone 6s, iPhone 7)
  - StoreKit purchase flow

### 6.3 App Store Preparation

**App Description**:
```
Discover fascinating moments from history, every single day.

Today in History delivers 5 curated historical facts from around the world — one each from North America, Europe, Asia, Africa, and South America. Each fact is a 2-3 minute read, perfect for your morning coffee or commute.

FREE FEATURES
• 5 daily facts from 5 world regions
• Beautiful, readable presentation
• Save favorites for later
• Share facts with friends
• Light and dark mode

PRO FEATURES
• Customize topics (Sports, Politics, Science, and more)
• Regenerate facts up to 5 times daily
• Ad-free experience
• Support independent development

Learn something new every day. Download Today in History.
```

**Keywords**: history, daily facts, education, world history, historical events, today, learning, culture

**Privacy Policy Requirements**:
- Data collected: Anonymous usage, favorites (if signed in)
- No tracking across apps
- No data sold to third parties

---

## Milestones Summary

| # | Milestone | Deliverable | Year | Est. Effort |
|---|-----------|-------------|------|-------------|
| M1 | Foundation | Project setup, Supabase, Edge Functions | 3 | — |
| M2 | Core Loop | Auth, fact fetching, basic display | 3 | — |
| M3 | Full UI | All screens, navigation, design system | 3 | — |
| M4 | Pro Features | StoreKit, preferences, regeneration | 5 | — |
| M5 | Polish | Accessibility, notifications, error handling | 5 | — |
| M6 | Launch | Testing, TestFlight, App Store submission | 5 | — |

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Wikipedia API rate limits | Medium | High | Server-side caching via Edge Function, daily batch fetch |
| Inconsistent regional content | High | Medium | Fallback to broader categories, manual content review V2 |
| StoreKit review delays | Medium | Medium | Submit 2 weeks early, clear IAP descriptions |
| iOS 15 SwiftUI limitations | Low | Low | Use NavigationView (not NavigationStack) for iOS 15 compat |
| Guest → Pro data loss | Medium | High | Implement account linking with data preservation |
| Wikipedia images failing | High | Low | 3-tier fallback: Wiki → Commons → placeholder |

---

## Configuration Answers (Locked)

| Question | Answer |
|----------|--------|
| Notification timing | Default 8:00 AM local time |
| Analytics | Skip for V1 |
| iPad optimization | iPhone-first, basic iPad scaling |
| Offline duration | 7 days cached |

---

## Appendix: Supabase Edge Functions

### generate-facts (Daily cron)
Generates 15 facts from Wikipedia at midnight UTC.

### validate-receipt
Validates StoreKit transactions with Apple's servers, updates user's `is_pro` status.

---

*Plan approved by Headmaster: 2026-02-17*
*Implementation ready to begin.*
