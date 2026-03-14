import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {

    // MARK: - Base Colors

    let background = Color("Background")
    let cardBackground = Color("CardBackground")
    let primaryText = Color("PrimaryText")
    let secondaryText = Color("SecondaryText")
    let accent = Color("Accent")
    let proGold = Color("ProGold")

    // MARK: - Region Colors

    let northAmerica = Color("NorthAmerica")
    let europe = Color("Europe")
    let asia = Color("Asia")
    let africa = Color("Africa")
    let southAmerica = Color("SouthAmerica")

    // MARK: - Semantic Colors

    let success = Color.green
    let warning = Color.orange
    let error = Color.red

    // MARK: - Fallback Colors (if Asset Catalog not set up)

    static let fallbackBackground = Color(uiColor: .systemBackground)
    static let fallbackCard = Color(uiColor: .secondarySystemBackground)
    static let fallbackPrimaryText = Color(uiColor: .label)
    static let fallbackSecondaryText = Color(uiColor: .secondaryLabel)
    static let fallbackAccent = Color.blue
    static let fallbackProGold = Color.yellow

    // Region fallbacks
    static let fallbackNorthAmerica = Color.blue
    static let fallbackEurope = Color.indigo
    static let fallbackAsia = Color.red
    static let fallbackAfrica = Color.orange
    static let fallbackSouthAmerica = Color.green
}

// MARK: - Color Set Reference

/*
 Add these colors to Assets.xcassets:

 Background:
   - Light: #FFFFFF
   - Dark: #000000

 CardBackground:
   - Light: #F5F5F5
   - Dark: #1C1C1E

 PrimaryText:
   - Light: #000000
   - Dark: #FFFFFF

 SecondaryText:
   - Light: #666666
   - Dark: #8E8E93

 Accent:
   - Any: #007AFF (iOS Blue)

 ProGold:
   - Any: #FFD700

 NorthAmerica:
   - Any: #3B82F6 (Blue)

 Europe:
   - Any: #6366F1 (Indigo)

 Asia:
   - Any: #EF4444 (Red)

 Africa:
   - Any: #F97316 (Orange)

 SouthAmerica:
   - Any: #22C55E (Green)
*/
