import SwiftUI

struct LoyaltyCard: View {
    let memberName: String
    let stars: Int
    let totalStars: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("REWARDS")
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(memberName)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "cup.and.saucer.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(stars) / \(totalStars) stars")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(stars >= totalStars ? "Reward ready!" : "\(totalStars - stars) to go")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.85))
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.2))
                        Capsule()
                            .fill(.white)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 10)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.coffeeEspresso, Color.coffeeAccent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.coffeeEspresso.opacity(0.25), radius: 12, y: 6)
    }

    private var progress: CGFloat {
        guard totalStars > 0 else { return 0 }
        return min(1, CGFloat(stars) / CGFloat(totalStars))
    }
}

struct SubscriptionPlanCard: View {
    let title: String
    let cadence: String
    let pricePerMonth: String
    let perks: [String]
    let isFeatured: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                if isFeatured {
                    Text("POPULAR")
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.coffeeAccent))
                        .foregroundStyle(.white)
                }
            }

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(pricePerMonth)
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundStyle(Color.coffeeEspresso)
                Text("/month")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text("Delivered \(cadence)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(perks, id: \.self) { perk in
                    Label {
                        Text(perk).font(.subheadline)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isFeatured ? Color.coffeeAccent : .clear, lineWidth: 2)
                )
        )
    }
}

struct BaristaProfileCard: View {
    let name: String
    let title: String
    let yearsOfExperience: Int
    let specialties: [String]
    let avatarSymbol: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.coffeeCream)
                    .frame(width: 64, height: 64)
                Image(systemName: avatarSymbol)
                    .font(.title)
                    .foregroundStyle(Color.coffeeEspresso)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(yearsOfExperience) yrs · \(specialties.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(Color.coffeeAccent)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.blue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct ReviewCard: View {
    let reviewer: String
    let date: String
    let rating: Int
    let title: String
    let comment: String
    let verified: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(reviewer).font(.subheadline.weight(.semibold))
                        if verified {
                            Label("Verified", systemImage: "checkmark.seal.fill")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.blue)
                                .font(.caption)
                        }
                    }
                    Text(date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
            }
            Text(title).font(.headline)
            Text(comment)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview("LoyaltyCard / In Progress") {
    LoyaltyCard(memberName: "Cam Cooke", stars: 7, totalStars: 12).padding()
}

#Preview("LoyaltyCard / Empty") {
    LoyaltyCard(memberName: "New Member", stars: 0, totalStars: 12).padding()
}

#Preview("LoyaltyCard / Ready") {
    LoyaltyCard(memberName: "Cam Cooke", stars: 12, totalStars: 12).padding()
}

#Preview("LoyaltyCard / Almost There") {
    LoyaltyCard(memberName: "Cam Cooke", stars: 11, totalStars: 12).padding()
}

#Preview("SubscriptionPlanCard / Weekly Featured") {
    SubscriptionPlanCard(
        title: "Weekly Roast",
        cadence: "every 7 days",
        pricePerMonth: "$48",
        perks: ["Free shipping", "Rotating origins", "Cancel anytime"],
        isFeatured: true
    )
    .padding()
}

#Preview("SubscriptionPlanCard / Monthly Standard") {
    SubscriptionPlanCard(
        title: "Monthly Pick",
        cadence: "every 30 days",
        pricePerMonth: "$24",
        perks: ["10% off all add-ons", "Pause anytime"],
        isFeatured: false
    )
    .padding()
}

#Preview("SubscriptionPlanCard / Side By Side") {
    HStack(alignment: .top, spacing: 12) {
        SubscriptionPlanCard(
            title: "Monthly",
            cadence: "every 30 days",
            pricePerMonth: "$24",
            perks: ["Free shipping", "Pause anytime"],
            isFeatured: false
        )
        SubscriptionPlanCard(
            title: "Weekly",
            cadence: "every 7 days",
            pricePerMonth: "$48",
            perks: ["Rotating origins", "Priority support"],
            isFeatured: true
        )
    }
    .padding()
}

#Preview("BaristaProfileCard / Head Barista") {
    BaristaProfileCard(
        name: "Marta Reyes",
        title: "Head Barista",
        yearsOfExperience: 8,
        specialties: ["Latte art", "Espresso dialing"],
        avatarSymbol: "person.fill"
    )
    .padding()
}

#Preview("BaristaProfileCard / Roaster") {
    BaristaProfileCard(
        name: "Jordan Park",
        title: "Lead Roaster",
        yearsOfExperience: 12,
        specialties: ["Sample roasting", "Cupping"],
        avatarSymbol: "flame.fill"
    )
    .padding()
}

#Preview("ReviewCard / Five Stars Verified") {
    ReviewCard(
        reviewer: "Alex T.",
        date: "Mar 12, 2026",
        rating: 5,
        title: "Best Yirgacheffe I've had",
        comment: "Bright, floral, and clean. Tasted exactly like the notes promised. Will reorder.",
        verified: true
    )
    .padding()
}

#Preview("ReviewCard / Three Stars Unverified") {
    ReviewCard(
        reviewer: "Sam W.",
        date: "Feb 28, 2026",
        rating: 3,
        title: "Decent but inconsistent",
        comment: "Some bags were great, others tasted muted. Shipping was quick though.",
        verified: false
    )
    .padding()
}

#Preview("ReviewCard / One Star") {
    ReviewCard(
        reviewer: "Riley K.",
        date: "Jan 04, 2026",
        rating: 1,
        title: "Stale on arrival",
        comment: "Roast date was over 2 months old. Not what I expect at this price.",
        verified: true
    )
    .padding()
}
