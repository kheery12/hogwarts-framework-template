import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()

                content
            }
            .navigationTitle("Today in History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    profileButton
                }
            }
            .refreshable {
                await viewModel.refresh(authService: authService)
            }
            .task {
                await viewModel.loadContent(authService: authService)
            }
            .onChange(of: authService.currentUser?.areaOfInterest) { _ in
                Task {
                    await viewModel.loadContent(authService: authService)
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.mainFact == nil {
            loadingView
        } else if let error = viewModel.error {
            ErrorView(error: error) {
                await viewModel.refresh(authService: authService)
            }
        } else if viewModel.mainFact == nil {
            emptyView
        } else {
            mainScrollView
        }
    }

    // MARK: - Main Scroll View

    private var mainScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.cardGap) {
                // Date subtitle
                Text(dateSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, Spacing.screenPadding)

                // Hero fact card
                if let fact = viewModel.mainFact {
                    heroCard(fact: fact)
                }

                // "Around the World" section
                if !viewModel.contextRows.isEmpty {
                    aroundTheWorldSection
                }
            }
            .padding(.vertical, Spacing.md)
        }
    }

    // MARK: - Hero Card

    private func heroCard(fact: Fact) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero image
            heroImage(for: fact)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Region badge
                RegionBadge(region: fact.region)

                // Title
                Text(fact.title)
                    .font(.factTitle)
                    .foregroundColor(.theme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                // Summary
                Text(fact.summary)
                    .font(.factSummary)
                    .foregroundColor(.theme.secondaryText)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Read More button
                NavigationLink(destination: FactDetailView(fact: fact)) {
                    Text("Read More")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.xs)
                        .background(fact.region.color)
                        .cornerRadius(Spacing.chipRadius)
                }
                .padding(.top, Spacing.xxs)
            }
            .padding(Spacing.cardPadding)
        }
        .background(Color.theme.cardBackground)
        .cornerRadius(Spacing.cardRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
        .padding(.horizontal, Spacing.screenPadding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fact.region.displayName): \(fact.title)")
    }

    @ViewBuilder
    private func heroImage(for fact: Fact) -> some View {
        if let imageUrl = fact.imageUrl, let url = URL(string: imageUrl) {
            KFImage(url)
                .placeholder {
                    RegionPlaceholder(region: fact.region)
                }
                .resizable()
                .aspectRatio(16 / 9, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                .cornerRadius(Spacing.cardRadius, corners: [.topLeft, .topRight])
        } else {
            RegionPlaceholder(region: fact.region)
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .cornerRadius(Spacing.cardRadius, corners: [.topLeft, .topRight])
        }
    }

    // MARK: - Around the World Section

    private var aroundTheWorldSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Around the World")
                .font(.sectionHeader)
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, Spacing.xs)

            VStack(spacing: 0) {
                ForEach(viewModel.contextRows) { context in
                    WorldContextRow(
                        context: context,
                        isExpanded: viewModel.expandedRegion == context.contextRegion
                    ) {
                        viewModel.toggleRegion(context.contextRegion)
                    }

                    if context.id != viewModel.contextRows.last?.id {
                        Divider()
                            .padding(.leading, Spacing.screenPadding)
                    }
                }
            }
            .background(Color.theme.cardBackground)
            .cornerRadius(Spacing.cardRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            .padding(.horizontal, Spacing.screenPadding)
        }
    }

    // MARK: - State Views

    private var loadingView: some View {
        VStack(spacing: Spacing.cardGap) {
            SkeletonFactCard()
            SkeletonFactCard()
        }
        .padding()
    }

    private var emptyView: some View {
        EmptyStateView(
            icon: "calendar.badge.exclamationmark",
            title: "No Facts Available",
            message: "Check back soon for today's historical discoveries."
        )
    }

    // MARK: - Profile Button

    private var profileButton: some View {
        NavigationLink(destination: ProfileView().environmentObject(authService)) {
            Image(systemName: "person.circle")
                .font(.system(size: 22))
        }
    }

    // MARK: - Helpers

    private var dateSubtitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - World Context Row

struct WorldContextRow: View {
    let context: WorldContext
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Row header (always visible)
            Button(action: onTap) {
                HStack(spacing: 0) {
                    // Left accent bar
                    Rectangle()
                        .fill(context.contextRegion.color)
                        .frame(width: 4)

                    HStack(spacing: Spacing.sm) {
                        // Region icon
                        Image(systemName: context.contextRegion.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(context.contextRegion.color)
                            .frame(width: 28)

                        // Region name + era label
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.contextRegion.displayName)
                                .font(.subheadline.bold())
                                .foregroundColor(.theme.primaryText)

                            Text(context.eraLabel)
                                .font(.caption)
                                .foregroundColor(.theme.secondaryText)
                        }

                        Spacer()

                        // Chevron
                        Image(systemName: "chevron.down")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.easeInOut(duration: 0.25), value: isExpanded)
                            .padding(.trailing, Spacing.md)
                    }
                    .padding(.vertical, Spacing.sm)
                    .padding(.leading, Spacing.sm)
                }
                .frame(minHeight: 56)
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                Text(context.content)
                    .font(.factSummary)
                    .foregroundColor(.theme.primaryText)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 4 + Spacing.sm + 28 + Spacing.sm)
                    .padding(.trailing, Spacing.md)
                    .padding(.bottom, Spacing.md)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(context.contextRegion.displayName), \(context.eraLabel)")
        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
    }
}

// MARK: - Preview

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthService())
    }
}
#endif
