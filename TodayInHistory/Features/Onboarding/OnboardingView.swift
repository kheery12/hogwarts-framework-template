import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthService
    @State private var currentPage = 0
    @State private var showAreaSelection = false

    private let pages = [
        OnboardingPage(
            title: "Discover History",
            subtitle: "5 fascinating facts daily from around the world",
            imageName: "globe.americas.fill",
            imageColor: .blue
        ),
        OnboardingPage(
            title: "Explore Cultures",
            subtitle: "Stories from North America, Europe, Asia, Africa, and South America",
            imageName: "map.fill",
            imageColor: .green
        ),
        OnboardingPage(
            title: "Your World",
            subtitle: "Choose your region and we'll personalise your daily history feed",
            imageName: "globe",
            imageColor: .indigo
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Page content
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Bottom actions
            VStack(spacing: Spacing.md) {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { result in
                    Task {
                        try? await authService.handleAppleSignIn(result)
                        showAreaSelection = authService.isAuthenticated
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(10)

                Button("Continue as Guest") {
                    Task {
                        try? await authService.continueAsGuest()
                        showAreaSelection = authService.isAuthenticated
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.theme.background)
        .loadingOverlay(authService.isLoading)
        .fullScreenCover(isPresented: $showAreaSelection) {
            AreaSelectionView { region in
                Task {
                    try? await authService.setAreaOfInterest(region)
                    showAreaSelection = false
                }
            }
        }
    }
}

// MARK: - Onboarding Page Model

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let imageColor: Color
}

// MARK: - Onboarding Page View

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(page.imageColor)
                .padding(.bottom, Spacing.lg)

            // Title
            Text(page.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            // Subtitle
            Text(page.subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)

            Spacer()
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AuthService())
    }
}
#endif
