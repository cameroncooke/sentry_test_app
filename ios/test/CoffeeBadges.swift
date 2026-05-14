import SwiftUI

struct RoastLevelBadge: View {
    let roast: RoastLevel

    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < roast.indicatorCount ? roast.color : Color.gray.opacity(0.25))
                        .frame(width: 8, height: 8)
                }
            }
            Text(roast.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color(.systemGray6)))
    }
}

struct BrewMethodBadge: View {
    let method: BrewMethod

    var body: some View {
        Label {
            Text(method.rawValue)
                .font(.caption.weight(.semibold))
        } icon: {
            Image(systemName: method.symbol)
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundStyle(Color.coffeeEspresso)
        .background(Capsule().fill(Color.coffeeCream))
    }
}

struct DiscountBadge: View {
    let percentOff: Int

    var body: some View {
        Text("-\(percentOff)%")
            .font(.caption.weight(.heavy))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.red)
            )
    }
}

struct StockPill: View {
    let status: StockStatus

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: statusSymbol)
                .font(.caption2.weight(.bold))
                .foregroundStyle(status.color)
            Text(status.label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule().fill(status.color.opacity(0.14))
        )
    }

    private var statusSymbol: String {
        switch status {
        case .inStock: return "checkmark.circle.fill"
        case .lowStock: return "exclamationmark.triangle.fill"
        case .outOfStock: return "xmark.circle.fill"
        case .preorder: return "calendar.badge.clock"
        }
    }
}

struct PriceTag: View {
    let price: String
    let originalPrice: String?
    let size: Size

    enum Size { case compact, large }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(price)
                .font(size == .large ? .title2.weight(.bold) : .headline.weight(.bold))
                .foregroundStyle(Color.coffeeEspresso)
            if let originalPrice {
                Text(originalPrice)
                    .font(size == .large ? .subheadline : .caption)
                    .foregroundStyle(.secondary)
                    .strikethrough(true, color: .secondary)
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool

    var body: some View {
        Label {
            Text(title)
                .font(.subheadline.weight(.semibold))
        } icon: {
            Image(systemName: icon)
                .font(.subheadline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .foregroundStyle(isSelected ? .white : Color.coffeeEspresso)
        .background(
            Capsule()
                .fill(isSelected ? Color.coffeeEspresso : Color.coffeeCream)
        )
    }
}

struct TastingNoteTag: View {
    let note: String

    var body: some View {
        Text(note)
            .font(.caption.weight(.medium))
            .foregroundStyle(Color.coffeeAccent)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .overlay(
                Capsule().stroke(Color.coffeeAccent.opacity(0.4), lineWidth: 1)
            )
    }
}

#Preview("RoastLevelBadge / Light") {
    RoastLevelBadge(roast: .light).padding()
}

#Preview("RoastLevelBadge / Medium") {
    RoastLevelBadge(roast: .medium).padding()
}

#Preview("RoastLevelBadge / MediumDark") {
    RoastLevelBadge(roast: .mediumDark).padding()
}

#Preview("RoastLevelBadge / Dark") {
    RoastLevelBadge(roast: .dark).padding()
}

#Preview("RoastLevelBadge / All Levels Stack") {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(RoastLevel.allCases) { level in
            RoastLevelBadge(roast: level)
        }
    }
    .padding()
}

#Preview("BrewMethodBadge / Espresso") {
    BrewMethodBadge(method: .espresso).padding()
}

#Preview("BrewMethodBadge / PourOver") {
    BrewMethodBadge(method: .pourOver).padding()
}

#Preview("BrewMethodBadge / ColdBrew") {
    BrewMethodBadge(method: .coldBrew).padding()
}

#Preview("BrewMethodBadge / All Methods Grid") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], spacing: 12) {
        ForEach(BrewMethod.allCases) { method in
            BrewMethodBadge(method: method)
        }
    }
    .padding()
}

#Preview("DiscountBadge / 10 Percent") {
    DiscountBadge(percentOff: 10).padding()
}

#Preview("DiscountBadge / 25 Percent") {
    DiscountBadge(percentOff: 25).padding()
}

#Preview("DiscountBadge / 50 Percent") {
    DiscountBadge(percentOff: 50).padding()
}

#Preview("StockPill / In Stock") {
    StockPill(status: .inStock(remaining: 42)).padding()
}

#Preview("StockPill / Low Stock") {
    StockPill(status: .lowStock(remaining: 3)).padding()
}

#Preview("StockPill / Sold Out") {
    StockPill(status: .outOfStock).padding()
}

#Preview("StockPill / Preorder") {
    StockPill(status: .preorder(shipDate: "Jun 12")).padding()
}

#Preview("PriceTag / Compact Regular") {
    PriceTag(price: "$18.50", originalPrice: nil, size: .compact).padding()
}

#Preview("PriceTag / Compact Sale") {
    PriceTag(price: "$14.99", originalPrice: "$22.00", size: .compact).padding()
}

#Preview("PriceTag / Large Regular") {
    PriceTag(price: "$26.50", originalPrice: nil, size: .large).padding()
}

#Preview("PriceTag / Large Sale") {
    PriceTag(price: "$19.95", originalPrice: "$29.50", size: .large).padding()
}

#Preview("CategoryChip / Selected") {
    CategoryChip(title: "Single Origin", icon: "globe", isSelected: true).padding()
}

#Preview("CategoryChip / Unselected") {
    CategoryChip(title: "Blends", icon: "drop.halffull", isSelected: false).padding()
}

#Preview("CategoryChip / Group Row") {
    HStack {
        CategoryChip(title: "All", icon: "sparkles", isSelected: true)
        CategoryChip(title: "Espresso", icon: "cup.and.saucer.fill", isSelected: false)
        CategoryChip(title: "Decaf", icon: "moon.fill", isSelected: false)
    }
    .padding()
}

#Preview("TastingNoteTag / Single") {
    TastingNoteTag(note: "Bergamot").padding()
}

#Preview("TastingNoteTag / Cluster") {
    HStack {
        TastingNoteTag(note: "Caramel")
        TastingNoteTag(note: "Citrus")
        TastingNoteTag(note: "Dark Chocolate")
    }
    .padding()
}
