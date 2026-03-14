import SwiftUI

struct TopicChip: View {
    let topic: String

    private var topicEnum: Topic? {
        Topic(rawValue: topic)
    }

    var body: some View {
        HStack(spacing: 4) {
            if let t = topicEnum {
                Image(systemName: t.iconName)
                    .font(.caption2)
            }

            Text(topicEnum?.displayName ?? topic.capitalized)
                .font(.badge)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(chipColor.opacity(0.15))
        .foregroundColor(chipColor)
        .cornerRadius(Spacing.chipRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Topic: \(topicEnum?.displayName ?? topic)")
    }

    private var chipColor: Color {
        topicEnum?.color ?? .gray
    }
}

// MARK: - Preview

#if DEBUG
struct TopicChip_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            ForEach(Topic.allCases) { topic in
                TopicChip(topic: topic.rawValue)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
