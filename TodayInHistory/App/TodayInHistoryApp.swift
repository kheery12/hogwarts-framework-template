import SwiftUI

@main
struct TodayInHistoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        Group {
            if authService.isAuthenticated {
                MainTabView()
                    .fullScreenCover(isPresented: .constant(authService.needsAreaSelection)) {
                        AreaSelectionView { region in
                            Task {
                                try? await authService.setAreaOfInterest(region)
                            }
                        }
                    }
            } else {
                OnboardingView()
            }
        }
        .task {
            await authService.checkSession()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
