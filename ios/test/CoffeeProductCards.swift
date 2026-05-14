import SwiftUI

struct CoffeeProductCard: View {
    let product: CoffeeProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.coffeeCream)
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: product.imageSymbol)
                            .font(.system(size: 56))
                            .foregroundStyle(Color.coffeeAccent.opacity(0.55))
                    )
                if product.isOnSale, let original = product.originalPriceCents {
                    let pct = Int(round((1.0 - Double(product.priceCents) / Double(original)) * 100))
                    DiscountBadge(percentOff: pct)
                        .padding(10)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.origin.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.coffeeAccent)
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption.weight(.semibold))
                    Text("(\(product.reviewCount))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                PriceTag(price: product.price, originalPrice: product.originalPrice, size: .compact)
                Spacer()
                StockPill(status: product.stock)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct FeaturedProductCard: View {
    let product: CoffeeProduct

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.coffeeEspresso, Color.coffeeAccent, Color.coffeeAccent.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

            Image(systemName: product.imageSymbol)
                .font(.system(size: 220))
                .foregroundStyle(.white.opacity(0.14))
                .rotationEffect(.degrees(-12))
                .offset(x: 90, y: 10)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text("FEATURED")
                        .font(.caption.weight(.heavy))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.22)))
                        .foregroundStyle(.white)
                    Label(product.origin, systemImage: "globe")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.22)))
                        .foregroundStyle(.white)
                }
                Text(product.name)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text(product.tastingNotes.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                HStack {
                    Text(product.price)
                        .font(.title2.bold().monospacedDigit())
                        .foregroundStyle(.white)
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Shop now")
                            .font(.subheadline.weight(.semibold))
                        Image(systemName: "arrow.right")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(Color.coffeeEspresso)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(.white))
                }
            }
            .padding(22)
        }
        .frame(height: 240)
    }
}

struct ProductDetailHeader: View {
    let product: CoffeeProduct

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.coffeeCream)
                    .frame(width: 200, height: 200)
                Image(systemName: product.imageSymbol)
                    .font(.system(size: 90))
                    .foregroundStyle(Color.coffeeAccent)
            }

            VStack(spacing: 6) {
                Text(product.origin.uppercased())
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.coffeeAccent)
                    .tracking(2)
                Text(product.name)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 8) {
                ForEach(product.tastingNotes, id: \.self) { note in
                    TastingNoteTag(note: note)
                }
            }

            HStack(spacing: 12) {
                RoastLevelBadge(roast: product.roast)
                StockPill(status: product.stock)
            }

            PriceTag(price: product.price, originalPrice: product.originalPrice, size: .large)
        }
        .padding()
    }
}

struct ProductGridSection: View {
    let title: String
    let products: [CoffeeProduct]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal, 4)
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(products) { product in
                    CoffeeProductCard(product: product)
                }
            }
        }
        .padding()
    }
}

#Preview("CoffeeProductCard / Light Roast Regular") {
    CoffeeProductCard(product: SampleData.ethiopia)
        .padding()
        .frame(width: 220)
}

#Preview("CoffeeProductCard / On Sale Low Stock") {
    CoffeeProductCard(product: SampleData.colombia)
        .padding()
        .frame(width: 220)
}

#Preview("CoffeeProductCard / Sold Out Dark") {
    CoffeeProductCard(product: SampleData.sumatra)
        .padding()
        .frame(width: 220)
}

#Preview("CoffeeProductCard / Preorder") {
    CoffeeProductCard(product: SampleData.kenya)
        .padding()
        .frame(width: 220)
}

#Preview("FeaturedProductCard / Ethiopia") {
    FeaturedProductCard(product: SampleData.ethiopia).padding()
}

#Preview("FeaturedProductCard / Kenya") {
    FeaturedProductCard(product: SampleData.kenya).padding()
}

#Preview("ProductDetailHeader / Yirgacheffe") {
    ScrollView { ProductDetailHeader(product: SampleData.ethiopia) }
}

#Preview("ProductDetailHeader / Huila Sale") {
    ScrollView { ProductDetailHeader(product: SampleData.colombia) }
}

#Preview("ProductDetailHeader / Sumatra Sold Out") {
    ScrollView { ProductDetailHeader(product: SampleData.sumatra) }
}

#Preview("ProductGridSection / Two by Two") {
    ScrollView {
        ProductGridSection(title: "Trending Beans", products: SampleData.all)
    }
}
