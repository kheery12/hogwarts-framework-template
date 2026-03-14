import SwiftUI
import Kingfisher

struct FactDetailView: View {
    let fact: Fact

    @StateObject private var viewModel: FactDetailViewModel
    @EnvironmentObject var authService: AuthService
    @Environment(\.openURL) private var openURL
    @State private var showShareSheet = false

    init(fact: Fact) {
        self.fact = fact
        self._viewModel = StateObject(wrappedValue: FactDetailViewModel(fact: fact))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                heroImage

                // Content
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Metadata row
                    metadataRow

                    // Title
                    Text(fact.title)
                        .font(.title.bold())
                        .foregroundColor(.theme.primaryText)

                    // Full content
                    Text(fact.fullContent)
                        .font(.factBody)
                        .foregroundColor(.theme.primaryText)
                        .lineSpacing(6)

                    // Read more link
                    readMoreButton

                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Share button
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                // Favorite button
                Button {
                    Task {
                        await viewModel.toggleFavorite(userId: authService.currentUser?.id)
                    }
                } label: {
                    Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorited ? .red : .primary)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [fact.shareText, URL(string: fact.sourceUrl)!])
        }
        .task {
            await viewModel.checkFavoriteStatus(userId: authService.currentUser?.id)
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        Group {
            if let imageUrl = fact.imageUrl, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        RegionPlaceholder(region: fact.region)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } else {
                RegionPlaceholder(region: fact.region)
                    .frame(height: 250)
            }
        }
    }

    // MARK: - Metadata Row

    private var metadataRow: some View {
        HStack(spacing: Spacing.sm) {
            RegionBadge(region: fact.region)
            TopicChip(topic: fact.topic)
            Spacer()
        }
    }

    // MARK: - Read More Button

    private var readMoreButton: some View {
        Button {
            if let url = URL(string: fact.sourceUrl) {
                openURL(url)
            }
        } label: {
            HStack {
                Image(systemName: "safari")
                Text("Read Full Article on Wikipedia")
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

// MARK: - Share Sheet (UIKit wrapper for iOS 15)

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#if DEBUG
struct FactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FactDetailView(
                fact: Fact(
                    id: UUID(),
                    date: Date(),
                    region: .northAmerica,
                    setNumber: 1,
                    topic: "science",
                    title: "Apollo 11 Moon Landing",
                    summary: "NASA's Apollo 11 mission successfully lands the first humans on the Moon.",
                    fullContent: """
                    On July 20, 1969, American astronauts Neil Armstrong and Edwin "Buzz" Aldrin became the first humans to walk on the Moon. Armstrong stepped onto the lunar surface and described the event as "one small step for man, one giant leap for mankind."

                    The Apollo 11 mission was launched on July 16, 1969, from Kennedy Space Center in Florida. The crew consisted of Commander Neil Armstrong, Lunar Module Pilot Buzz Aldrin, and Command Module Pilot Michael Collins.

                    The landing was watched by an estimated 600 million people worldwide, making it one of the most viewed events in human history. The astronauts spent about two and a quarter hours outside the spacecraft, collecting lunar material to bring back to Earth.
                    """,
                    imageUrl: nil,
                    sourceUrl: "https://en.wikipedia.org/wiki/Apollo_11",
                    createdAt: Date()
                )
            )
        }
        .environmentObject(AuthService())
    }
}
#endif
