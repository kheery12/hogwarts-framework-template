import SwiftUI

extension Font {

    // MARK: - Fact Display

    /// Large title for fact cards and detail view
    static let factTitle: Font = .system(.title2, design: .serif).weight(.semibold)

    /// Body text for fact content
    static let factBody: Font = .system(.body, design: .serif)

    /// Summary text under titles
    static let factSummary: Font = .system(.subheadline, design: .serif)

    // MARK: - UI Elements

    /// Subtitle text for cards
    static let cardSubtitle: Font = .system(.subheadline, design: .default)

    /// Badge and chip text
    static let badge: Font = .system(.caption, design: .default).weight(.medium)

    /// Small caption text
    static let caption: Font = .system(.caption2, design: .default)

    // MARK: - Headlines

    /// Section headers
    static let sectionHeader: Font = .system(.headline, design: .default).weight(.semibold)

    /// Screen titles (used with navigationTitle)
    static let screenTitle: Font = .system(.largeTitle, design: .default).weight(.bold)
}

// MARK: - Text Styles

extension Text {

    func factTitleStyle() -> some View {
        self
            .font(.factTitle)
            .foregroundColor(.theme.primaryText)
    }

    func factBodyStyle() -> some View {
        self
            .font(.factBody)
            .foregroundColor(.theme.primaryText)
            .lineSpacing(6)
    }

    func secondaryStyle() -> some View {
        self
            .font(.cardSubtitle)
            .foregroundColor(.theme.secondaryText)
    }

    func badgeStyle() -> some View {
        self
            .font(.badge)
            .foregroundColor(.theme.secondaryText)
    }
}
