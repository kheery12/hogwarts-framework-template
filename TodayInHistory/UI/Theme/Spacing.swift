import SwiftUI

enum Spacing {

    // MARK: - Base Units

    /// 4pt
    static let xxs: CGFloat = 4

    /// 8pt
    static let xs: CGFloat = 8

    /// 12pt
    static let sm: CGFloat = 12

    /// 16pt - Standard spacing
    static let md: CGFloat = 16

    /// 20pt
    static let lg: CGFloat = 20

    /// 24pt
    static let xl: CGFloat = 24

    /// 32pt
    static let xxl: CGFloat = 32

    // MARK: - Semantic Spacing

    /// Standard card padding
    static let cardPadding: CGFloat = md

    /// Standard screen padding
    static let screenPadding: CGFloat = md

    /// Space between cards in a list
    static let cardGap: CGFloat = md

    /// Space between elements inside a card
    static let cardInnerGap: CGFloat = sm

    /// Standard corner radius for cards
    static let cardRadius: CGFloat = 16

    /// Standard corner radius for chips/badges
    static let chipRadius: CGFloat = 8

    /// Standard corner radius for images
    static let imageRadius: CGFloat = 12
}

// MARK: - View Extensions

extension View {
    func cardPadding() -> some View {
        padding(Spacing.cardPadding)
    }

    func screenPadding() -> some View {
        padding(.horizontal, Spacing.screenPadding)
    }
}
