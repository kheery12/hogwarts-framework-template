import SwiftUI

struct ErrorView: View {
    let error: Error
    let retry: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Couldn't Load Facts")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                Task { await retry() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error loading facts. \(error.localizedDescription)")
        .accessibilityHint("Double tap to retry")
    }
}

// MARK: - Exhausted View (All Facts Seen)

struct ExhaustedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text("You've Seen Everything!")
                .font(.headline)

            Text("Check back tomorrow for new historical discoveries.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(Spacing.cardRadius)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("You've seen all available facts for today. Check back tomorrow for new content.")
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorView(error: APIError.networkError(URLError(.notConnectedToInternet))) {
                // retry
            }

            ExhaustedView()

            EmptyStateView(
                icon: "heart.slash",
                title: "No Favorites Yet",
                message: "Tap the heart icon on any fact to save it here.",
                actionTitle: "Browse Facts"
            ) {
                // action
            }
        }
    }
}
#endif
