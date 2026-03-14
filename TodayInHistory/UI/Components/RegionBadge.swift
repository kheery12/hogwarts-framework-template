import SwiftUI

struct RegionBadge: View {
    let region: Region

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: region.iconName)
                .font(.caption2)

            Text(region.displayName)
                .font(.badge)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(region.color.opacity(0.15))
        .foregroundColor(region.color)
        .cornerRadius(Spacing.chipRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Region: \(region.displayName)")
    }
}

// MARK: - Preview

#if DEBUG
struct RegionBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            ForEach(Region.allCases) { region in
                RegionBadge(region: region)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
