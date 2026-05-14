import SwiftUI

struct CartItemRow: View {
    let product: CoffeeProduct
    @Binding var quantity: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.coffeeCream)
                    .frame(width: 64, height: 64)
                Image(systemName: product.imageSymbol)
                    .font(.title)
                    .foregroundStyle(Color.coffeeAccent)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name).font(.subheadline.weight(.semibold))
                Text(product.origin)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                PriceTag(price: product.price, originalPrice: product.originalPrice, size: .compact)
            }
            Spacer()
            QuantityStepper(quantity: $quantity, range: 1...12)
        }
        .padding(.vertical, 8)
    }
}

struct CheckoutSummaryRow: View {
    let label: String
    let value: String
    var isTotal: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .subheadline)
                .foregroundStyle(isTotal ? .primary : .secondary)
            Spacer()
            Text(value)
                .font(isTotal ? .headline.monospacedDigit() : .subheadline.monospacedDigit())
                .foregroundStyle(isTotal ? Color.coffeeEspresso : .primary)
        }
        .padding(.vertical, 6)
    }
}

struct ReviewRow: View {
    let reviewer: String
    let date: String
    let rating: Int
    let snippet: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(reviewer).font(.subheadline.weight(.semibold))
                Spacer()
                HStack(spacing: 1) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                    }
                }
            }
            Text(snippet)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Text(date)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct FilterChipGroup: View {
    @Binding var selection: Set<String>
    let options: [(String, String)]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.0) { option in
                    let isSelected = selection.contains(option.0)
                    Button {
                        if isSelected { selection.remove(option.0) } else { selection.insert(option.0) }
                    } label: {
                        CategoryChip(title: option.0, icon: option.1, isSelected: isSelected)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SectionHeaderRow: View {
    let title: String
    let actionLabel: String?
    var action: () -> Void = {}

    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
            Spacer()
            if let label = actionLabel {
                Button(action: action) {
                    Text(label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.coffeeAccent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct CartItemPreviewWrapper: View {
    @State var qty: Int
    let product: CoffeeProduct
    var body: some View {
        CartItemRow(product: product, quantity: $qty).padding(.horizontal)
    }
}

private struct FilterPreviewWrapper: View {
    @State var selection: Set<String>
    var body: some View {
        FilterChipGroup(
            selection: $selection,
            options: [
                ("Single Origin", "globe"),
                ("Blends", "drop.halffull"),
                ("Decaf", "moon.fill"),
                ("Cold Brew", "snowflake"),
                ("Espresso", "cup.and.saucer.fill")
            ]
        )
    }
}

#Preview("CartItemRow / Standard Quantity") {
    CartItemPreviewWrapper(qty: 2, product: SampleData.ethiopia)
}

#Preview("CartItemRow / Sale Quantity") {
    CartItemPreviewWrapper(qty: 1, product: SampleData.colombia)
}

#Preview("CartItemRow / List") {
    List {
        CartItemPreviewWrapper(qty: 1, product: SampleData.ethiopia)
        CartItemPreviewWrapper(qty: 2, product: SampleData.colombia)
        CartItemPreviewWrapper(qty: 1, product: SampleData.kenya)
    }
    .listStyle(.plain)
}

#Preview("CheckoutSummaryRow / Subtotal") {
    CheckoutSummaryRow(label: "Subtotal", value: "$64.50").padding()
}

#Preview("CheckoutSummaryRow / Shipping Free") {
    CheckoutSummaryRow(label: "Shipping", value: "Free").padding()
}

#Preview("CheckoutSummaryRow / Total") {
    CheckoutSummaryRow(label: "Total", value: "$72.85", isTotal: true).padding()
}

#Preview("CheckoutSummaryRow / Full Block") {
    VStack {
        CheckoutSummaryRow(label: "Subtotal", value: "$64.50")
        CheckoutSummaryRow(label: "Shipping", value: "Free")
        CheckoutSummaryRow(label: "Tax", value: "$8.35")
        Divider()
        CheckoutSummaryRow(label: "Total", value: "$72.85", isTotal: true)
    }
    .padding()
}

#Preview("ReviewRow / Five Stars") {
    ReviewRow(
        reviewer: "Pat L.",
        date: "Apr 02, 2026",
        rating: 5,
        snippet: "Smooth, balanced, and a great daily drinker. Will reorder."
    )
    .padding(.horizontal)
}

#Preview("ReviewRow / Two Stars") {
    ReviewRow(
        reviewer: "Jamie R.",
        date: "Mar 14, 2026",
        rating: 2,
        snippet: "Acidity was too aggressive for my taste. Pulled inconsistently as espresso."
    )
    .padding(.horizontal)
}

#Preview("ReviewRow / List of Five") {
    List {
        ReviewRow(reviewer: "Pat L.", date: "Apr 02", rating: 5, snippet: "Loved it.")
        ReviewRow(reviewer: "Jamie R.", date: "Mar 14", rating: 2, snippet: "Too acidic for me.")
        ReviewRow(reviewer: "Sasha O.", date: "Mar 09", rating: 4, snippet: "Great as pour over.")
        ReviewRow(reviewer: "Chris N.", date: "Feb 28", rating: 5, snippet: "Best I've had.")
        ReviewRow(reviewer: "Riley K.", date: "Feb 12", rating: 3, snippet: "Decent, not exceptional.")
    }
    .listStyle(.plain)
}

#Preview("FilterChipGroup / Empty Selection") {
    FilterPreviewWrapper(selection: [])
}

#Preview("FilterChipGroup / Some Selected") {
    FilterPreviewWrapper(selection: ["Single Origin", "Cold Brew"])
}

#Preview("SectionHeaderRow / With Action") {
    SectionHeaderRow(title: "Best sellers", actionLabel: "See all")
}

#Preview("SectionHeaderRow / Without Action") {
    SectionHeaderRow(title: "New arrivals", actionLabel: nil)
}
