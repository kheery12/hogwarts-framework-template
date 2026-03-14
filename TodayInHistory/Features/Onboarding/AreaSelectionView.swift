import SwiftUI

struct AreaSelectionView: View {
    let onComplete: (Region) -> Void

    @State private var selectedRegion: Region?

    private let descriptors: [Region: String] = [
        .northAmerica: "The Americas & the modern world",
        .europe: "Empires, wars & revolutions",
        .asia: "Ancient civilisations & rising powers",
        .africa: "Kingdoms, independence & culture",
        .southAmerica: "Conquest, liberation & passion"
    ]

    // Layout in 2-column grid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: Spacing.sm) {
                Text("Your Area of Interest")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("We'll deliver daily history from your chosen region, with world context from the others.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.xl)

            // Region grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(Region.allCases) { region in
                        RegionSelectionCard(
                            region: region,
                            descriptor: descriptors[region] ?? "",
                            isSelected: selectedRegion == region
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedRegion = region
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.bottom, Spacing.xl)
            }

            // Continue button
            Button {
                if let region = selectedRegion {
                    onComplete(region)
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(selectedRegion != nil ? Color.theme.accent : Color.secondary.opacity(0.4))
                    .cornerRadius(12)
            }
            .disabled(selectedRegion == nil)
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

// MARK: - Region Selection Card

private struct RegionSelectionCard: View {
    let region: Region
    let descriptor: String
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Icon
            Image(systemName: region.iconName)
                .font(.system(size: 32))
                .foregroundColor(region.color)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Region name
            Text(region.displayName)
                .font(.headline)
                .foregroundColor(.theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            // Descriptor
            Text(descriptor)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)

            if isSelected {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(region.color)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .background(Color.theme.cardBackground)
        .cornerRadius(Spacing.cardRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.cardRadius)
                .stroke(
                    isSelected ? region.color : Color.clear,
                    lineWidth: 2
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(region.displayName): \(descriptor)")
        .accessibilityHint(isSelected ? "Selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Preview

#if DEBUG
struct AreaSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AreaSelectionView { region in
            print("Selected: \(region.displayName)")
        }
    }
}
#endif
