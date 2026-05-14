import SwiftUI

struct EmptyStateView: View {
    let symbol: String
    let title: String
    let message: String
    let primaryAction: String?
    var actionHandler: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.coffeeCream)
                    .frame(width: 120, height: 120)
                Image(systemName: symbol)
                    .font(.system(size: 52))
                    .foregroundStyle(Color.coffeeAccent)
            }
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            if let primaryAction {
                Button(action: actionHandler) {
                    Text(primaryAction)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule().fill(Color.coffeeEspresso)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct EmptyCartView: View {
    var body: some View {
        EmptyStateView(
            symbol: "cart",
            title: "Your cart is empty",
            message: "Browse our seasonal roasts to fill it up.",
            primaryAction: "Shop coffee"
        )
    }
}

struct EmptySearchView: View {
    let query: String
    var body: some View {
        EmptyStateView(
            symbol: "magnifyingglass",
            title: "No results",
            message: "We couldn't find anything for \u{201C}\(query)\u{201D}. Try a different roast, origin, or flavor.",
            primaryAction: "Clear filters"
        )
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        EmptyStateView(
            symbol: "heart",
            title: "No favorites yet",
            message: "Tap the heart on any coffee to save it for later.",
            primaryAction: "Discover coffees"
        )
    }
}

struct ErrorStateView: View {
    let title: String
    let detail: String
    var retry: () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text(title).font(.headline)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Button(action: retry) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(Capsule().fill(Color.coffeeAccent))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct OnboardingHeroView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.coffeeAccent, Color.coffeeEspresso],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
            VStack(spacing: 8) {
                Text("Welcome to Roastery")
                    .font(.largeTitle.bold())
                Text("Specialty coffee from small farms, roasted fresh each week.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding()
    }
}

#Preview("EmptyCartView / Default") {
    EmptyCartView()
}

#Preview("EmptySearchView / Short Query") {
    EmptySearchView(query: "papaya")
}

#Preview("EmptySearchView / Long Query") {
    EmptySearchView(query: "decaf cold brew Indonesian washed process")
}

#Preview("EmptyFavoritesView / Default") {
    EmptyFavoritesView()
}

#Preview("ErrorStateView / Network") {
    ErrorStateView(
        title: "Couldn't load coffee",
        detail: "Check your connection and try again."
    )
}

#Preview("ErrorStateView / Server") {
    ErrorStateView(
        title: "Something went wrong",
        detail: "Our roastery is having a moment. Please try again in a few seconds."
    )
}

#Preview("OnboardingHeroView / Default") {
    OnboardingHeroView()
}

#Preview("EmptyStateView / Custom Action") {
    EmptyStateView(
        symbol: "bell.slash",
        title: "Notifications off",
        message: "Enable alerts to know when limited drops go live.",
        primaryAction: "Enable notifications"
    )
}

#Preview("EmptyStateView / No Action") {
    EmptyStateView(
        symbol: "moon.zzz",
        title: "All caught up",
        message: "You've seen every new release this week.",
        primaryAction: nil
    )
}
