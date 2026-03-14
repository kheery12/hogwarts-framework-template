import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()

                content
            }
            .navigationTitle("Favorites")
            .task {
                await viewModel.loadFavorites(userId: authService.currentUser?.id)
            }
            .refreshable {
                await viewModel.loadFavorites(userId: authService.currentUser?.id)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.favorites.isEmpty {
            LoadingView(message: "Loading favorites...")
        } else if viewModel.favorites.isEmpty {
            emptyState
        } else {
            favoritesList
        }
    }

    // MARK: - Favorites List

    private var favoritesList: some View {
        List {
            ForEach(viewModel.favorites) { fact in
                NavigationLink(destination: FactDetailView(fact: fact)) {
                    FavoriteRow(fact: fact)
                }
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.removeFavorites(
                        at: indexSet,
                        userId: authService.currentUser?.id
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView(
            icon: "heart.slash",
            title: "No Favorites Yet",
            message: "Tap the heart icon on any fact to save it here for later reading."
        )
    }
}

// MARK: - Favorite Row

struct FavoriteRow: View {
    let fact: Fact

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Region color indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(fact.region.color)
                .frame(width: 4, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(fact.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: Spacing.xs) {
                    Text(fact.region.displayName)
                        .font(.caption)
                        .foregroundColor(fact.region.color)

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(fact.date.relativeFormat)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fact.title), from \(fact.region.displayName)")
    }
}

// MARK: - Preview

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(AuthService())
    }
}
#endif
