import SwiftUI
import Kingfisher

struct FactCard: View {
    let fact: Fact
    var isFavorited: Bool = false
    var onFavorite: (() -> Void)? = nil

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.cardInnerGap) {
            // Header: Region badge + favorite button
            HStack {
                RegionBadge(region: fact.region)
                Spacer()
                if let onFavorite = onFavorite {
                    favoriteButton(action: onFavorite)
                }
            }

            // Image
            factImage

            // Title
            Text(fact.title)
                .font(.factTitle)
                .foregroundColor(.theme.primaryText)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            // Summary
            Text(fact.summary)
                .font(.factSummary)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(3)

            // Topic chip
            TopicChip(topic: fact.topic)
        }
        .padding(Spacing.cardPadding)
        .background(Color.theme.cardBackground)
        .cornerRadius(Spacing.cardRadius)
        .shadow(color: shadowColor, radius: 8, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fact.region.displayName): \(fact.title)")
        .accessibilityHint("Double tap to read the full article")
    }

    // MARK: - Image

    private var factImage: some View {
        Group {
            if let imageUrl = fact.imageUrl, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        RegionPlaceholder(region: fact.region)
                    }
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(Spacing.imageRadius)
            } else {
                RegionPlaceholder(region: fact.region)
                    .frame(height: 180)
                    .cornerRadius(Spacing.imageRadius)
            }
        }
    }

    // MARK: - Favorite Button

    private func favoriteButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 20))
                .foregroundColor(isFavorited ? .red : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorited ? "Remove from favorites" : "Add to favorites")
    }

    // MARK: - Shadow

    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.1)
    }
}

// MARK: - Region Placeholder

struct RegionPlaceholder: View {
    let region: Region

    var body: some View {
        ZStack {
            region.color.opacity(0.2)

            VStack(spacing: 8) {
                Image(systemName: region.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(region.color.opacity(0.6))

                Text(region.displayName)
                    .font(.caption)
                    .foregroundColor(region.color.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(16/9, contentMode: .fill)
    }
}

// MARK: - Preview

#if DEBUG
struct FactCard_Previews: PreviewProvider {
    static var previews: some View {
        FactCard(
            fact: Fact(
                id: UUID(),
                date: Date(),
                region: .europe,
                setNumber: 1,
                topic: "history",
                title: "The Signing of the Magna Carta",
                summary: "King John of England signs the Magna Carta, establishing the principle that everyone, including the king, was subject to the law.",
                fullContent: "Full content here...",
                imageUrl: nil,
                sourceUrl: "https://en.wikipedia.org/wiki/Magna_Carta",
                createdAt: Date()
            ),
            isFavorited: false
        ) {
            print("Favorite tapped")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
