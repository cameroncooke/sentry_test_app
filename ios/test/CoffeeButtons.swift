import SwiftUI

struct AddToCartButton: View {
    enum State { case idle, adding, added, soldOut }

    let state: State
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(foreground)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(background)
            )
        }
        .buttonStyle(.plain)
        .disabled(state == .soldOut)
    }

    @ViewBuilder private var icon: some View {
        switch state {
        case .idle: Image(systemName: "cart.fill.badge.plus")
        case .adding: ProgressView().tint(.white)
        case .added: Image(systemName: "checkmark.circle.fill")
        case .soldOut: Image(systemName: "xmark.circle.fill")
        }
    }

    private var title: String {
        switch state {
        case .idle: return "Add to cart"
        case .adding: return "Adding…"
        case .added: return "Added"
        case .soldOut: return "Sold out"
        }
    }

    private var foreground: Color {
        state == .soldOut ? .secondary : .white
    }

    private var background: Color {
        switch state {
        case .idle, .adding: return Color.coffeeEspresso
        case .added: return .green
        case .soldOut: return Color(.systemGray5)
        }
    }
}

struct FavoriteButton: View {
    @Binding var isFavorite: Bool

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(isFavorite ? .red : .secondary)
                .padding(10)
                .background(
                    Circle().fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

struct QuantityStepper: View {
    @Binding var quantity: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack(spacing: 0) {
            stepButton(symbol: "minus", disabled: quantity <= range.lowerBound) {
                quantity = max(range.lowerBound, quantity - 1)
            }
            Text("\(quantity)")
                .font(.headline.monospacedDigit())
                .frame(minWidth: 36)
                .padding(.vertical, 8)
            stepButton(symbol: "plus", disabled: quantity >= range.upperBound) {
                quantity = min(range.upperBound, quantity + 1)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }

    private func stepButton(symbol: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.subheadline.weight(.semibold))
                .frame(width: 36, height: 36)
                .foregroundStyle(disabled ? .secondary : Color.coffeeEspresso)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct CheckoutCTAButton: View {
    let total: String
    let itemCount: Int
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bag.fill")
                        .font(.title3)
                    Text("\(itemCount)")
                        .font(.caption2.bold())
                        .foregroundStyle(Color.coffeeEspresso)
                        .padding(4)
                        .background(Circle().fill(.white))
                        .offset(x: 8, y: -8)
                }
                Text("Checkout")
                    .font(.headline)
                Spacer()
                Text(total)
                    .font(.headline.monospacedDigit())
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.coffeeEspresso)
            )
        }
        .buttonStyle(.plain)
    }
}

struct IconActionButton: View {
    let symbol: String
    let label: String
    var tint: Color = Color.coffeeAccent
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(tint)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(tint.opacity(0.12))
                    )
                Text(label)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct FavoritePreviewWrapper: View {
    @State private var fav = false
    var body: some View {
        FavoriteButton(isFavorite: $fav).padding()
    }
}

private struct QuantityPreviewWrapper: View {
    @State var qty: Int
    var body: some View {
        QuantityStepper(quantity: $qty, range: 1...12).padding()
    }
}

#Preview("AddToCartButton / Idle") {
    AddToCartButton(state: .idle).padding()
}

#Preview("AddToCartButton / Adding") {
    AddToCartButton(state: .adding).padding()
}

#Preview("AddToCartButton / Added") {
    AddToCartButton(state: .added).padding()
}

#Preview("AddToCartButton / SoldOut") {
    AddToCartButton(state: .soldOut).padding()
}

#Preview("FavoriteButton / Default") {
    FavoritePreviewWrapper()
}

#Preview("FavoriteButton / Active") {
    FavoriteButton(isFavorite: .constant(true)).padding()
}

#Preview("QuantityStepper / At Minimum") {
    QuantityPreviewWrapper(qty: 1)
}

#Preview("QuantityStepper / Middle") {
    QuantityPreviewWrapper(qty: 4)
}

#Preview("QuantityStepper / At Maximum") {
    QuantityPreviewWrapper(qty: 12)
}

#Preview("CheckoutCTAButton / Single Item") {
    CheckoutCTAButton(total: "$18.50", itemCount: 1).padding()
}

#Preview("CheckoutCTAButton / Many Items") {
    CheckoutCTAButton(total: "$124.85", itemCount: 7).padding()
}

#Preview("IconActionButton / Share") {
    IconActionButton(symbol: "square.and.arrow.up", label: "Share").padding()
}

#Preview("IconActionButton / Subscribe") {
    IconActionButton(symbol: "arrow.triangle.2.circlepath", label: "Subscribe", tint: .green).padding()
}

#Preview("IconActionButton / Row") {
    HStack(spacing: 24) {
        IconActionButton(symbol: "square.and.arrow.up", label: "Share")
        IconActionButton(symbol: "heart", label: "Save", tint: .pink)
        IconActionButton(symbol: "bell", label: "Notify", tint: .blue)
        IconActionButton(symbol: "info.circle", label: "Info", tint: .gray)
    }
    .padding()
}
