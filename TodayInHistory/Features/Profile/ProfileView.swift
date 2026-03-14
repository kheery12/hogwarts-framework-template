import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationView {
            List {
                // User section
                userSection

                // Area of Interest section
                areaOfInterestSection

                // Settings section
                settingsSection

                // App version
                appVersionSection

                // Account actions
                accountSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.showAreaSelection) {
                AreaSelectionView { region in
                    Task {
                        await viewModel.updateAreaOfInterest(region, authService: authService)
                        viewModel.showAreaSelection = false
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - User Section

    private var userSection: some View {
        Section {
            HStack(spacing: Spacing.md) {
                // Avatar
                Circle()
                    .fill(Color.theme.accent.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.theme.accent)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.headline)

                    Text(userStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var userName: String {
        authService.currentUser?.displayName ?? (authService.isGuest ? "Guest" : "User")
    }

    private var userStatus: String {
        authService.isGuest ? "Sign in to sync across devices" : "Member"
    }

    // MARK: - Area of Interest Section

    private var areaOfInterestSection: some View {
        Section("Area of Interest") {
            if let region = authService.currentUser?.areaOfInterest {
                HStack(spacing: Spacing.sm) {
                    // Region icon with color
                    Image(systemName: region.iconName)
                        .font(.title3)
                        .foregroundColor(region.color)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(region.displayName)
                            .font(.subheadline.bold())

                        Text("Your primary history region")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button("Change") {
                        viewModel.showAreaSelection = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.theme.accent)
                }
                .padding(.vertical, 4)
            } else {
                Button {
                    viewModel.showAreaSelection = true
                } label: {
                    HStack {
                        Label("Choose Your Region", systemImage: "globe")
                            .foregroundColor(.primary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
        }
    }

    // MARK: - Settings Section

    private var settingsSection: some View {
        Section("Settings") {
            NotificationToggleRow()

            NavigationLink {
                Text("Privacy Policy")
                    .padding()
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            NavigationLink {
                Text("Terms of Service")
                    .padding()
            } label: {
                Label("Terms of Service", systemImage: "doc.text")
            }
        }
    }

    // MARK: - App Version Section

    private var appVersionSection: some View {
        Section {
            HStack {
                Text("Version")
                    .foregroundColor(.secondary)
                Spacer()
                Text(appVersion)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    // MARK: - Account Section

    private var accountSection: some View {
        Section {
            if authService.isGuest {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { result in
                    Task {
                        try? await authService.handleAppleSignIn(result)
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 44)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }

            Button("Sign Out", role: .destructive) {
                Task {
                    try? await authService.signOut()
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct NotificationToggleRow: View {
    @State private var isEnabled = NotificationService.shared.isEnabled

    var body: some View {
        Toggle(isOn: $isEnabled) {
            Label("Daily Reminder", systemImage: "bell")
        }
        .onChange(of: isEnabled) { newValue in
            if newValue {
                Task {
                    let granted = await NotificationService.shared.requestPermission()
                    if granted {
                        NotificationService.shared.isEnabled = true
                    } else {
                        isEnabled = false
                    }
                }
            } else {
                NotificationService.shared.isEnabled = false
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthService())
    }
}
#endif
