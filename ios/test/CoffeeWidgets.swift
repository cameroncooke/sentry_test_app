import SwiftUI

struct DailySpecialBanner: View {
    let title: String
    let subtitle: String
    let discountLabel: String
    let endsAt: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 64, height: 64)
                Image(systemName: "sparkles")
                    .font(.title)
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text(subtitle).font(.subheadline).foregroundStyle(.white.opacity(0.85))
                Text("Ends \(endsAt)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }
            Spacer()
            Text(discountLabel)
                .font(.title3.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(.white))
                .foregroundStyle(Color.coffeeEspresso)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.coffeeAccent, Color.coffeeEspresso],
                startPoint: .leading, endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct StoreHoursWidget: View {
    struct DayHours: Identifiable {
        let id = UUID()
        let day: String
        let hours: String
        let isToday: Bool
    }

    let storeName: String
    let isOpen: Bool
    let days: [DayHours]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(storeName).font(.headline)
                    HStack(spacing: 6) {
                        Circle()
                            .fill(isOpen ? .green : .red)
                            .frame(width: 8, height: 8)
                        Text(isOpen ? "Open now" : "Closed")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(isOpen ? .green : .red)
                    }
                }
                Spacer()
                Image(systemName: "clock.fill")
                    .foregroundStyle(Color.coffeeAccent)
            }

            Divider()

            VStack(spacing: 6) {
                ForEach(days) { day in
                    HStack {
                        Text(day.day)
                            .font(.subheadline.weight(day.isToday ? .bold : .regular))
                        Spacer()
                        Text(day.hours)
                            .font(.subheadline.weight(day.isToday ? .bold : .regular))
                            .foregroundStyle(day.isToday ? Color.coffeeEspresso : .secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct DeliveryEstimateWidget: View {
    let address: String
    let etaMinutes: Int
    let isFast: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isFast ? "bolt.fill" : "shippingbox.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(isFast ? .orange : Color.coffeeAccent)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(isFast ? "Express delivery" : "Standard delivery")
                    .font(.subheadline.weight(.semibold))
                Text("To \(address)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(etaMinutes) min")
                    .font(.headline.monospacedDigit())
                Text("ETA")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct RatingSummaryWidget: View {
    let average: Double
    let total: Int
    let distribution: [Int]  // 5 stars first → 1 star

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(spacing: 4) {
                Text(String(format: "%.1f", average))
                    .font(.system(size: 44, weight: .heavy))
                    .foregroundStyle(Color.coffeeEspresso)
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: Double(i) < average ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
                Text("\(total) reviews")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 6) {
                ForEach(0..<5, id: \.self) { i in
                    let count = distribution[i]
                    let pct = total > 0 ? Double(count) / Double(total) : 0
                    HStack(spacing: 8) {
                        Text("\(5 - i)")
                            .font(.caption.monospacedDigit())
                            .frame(width: 12)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color(.systemGray5))
                                Capsule()
                                    .fill(Color.coffeeAccent)
                                    .frame(width: geo.size.width * pct)
                            }
                        }
                        .frame(height: 8)
                        Text("\(count)")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 32, alignment: .trailing)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct OrderStatusTimeline: View {
    enum Step: String, CaseIterable, Identifiable {
        case placed = "Order placed"
        case roasting = "Roasting"
        case shipped = "Shipped"
        case delivered = "Delivered"
        var id: String { rawValue }
        var symbol: String {
            switch self {
            case .placed: return "checkmark.circle.fill"
            case .roasting: return "flame.fill"
            case .shipped: return "shippingbox.fill"
            case .delivered: return "house.fill"
            }
        }
    }

    let currentStep: Step
    let estimatedDelivery: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Order #4821")
                .font(.headline)
            Text("Estimated delivery \(estimatedDelivery)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: 0) {
                ForEach(Array(Step.allCases.enumerated()), id: \.element.id) { index, step in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(isComplete(step) ? Color.coffeeAccent : Color(.systemGray5))
                                .frame(width: 36, height: 36)
                            Image(systemName: step.symbol)
                                .font(.subheadline)
                                .foregroundStyle(isComplete(step) ? .white : .secondary)
                        }
                        Text(step.rawValue)
                            .font(.caption2.weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(isComplete(step) ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)

                    if index < Step.allCases.count - 1 {
                        Rectangle()
                            .fill(isComplete(Step.allCases[index + 1]) ? Color.coffeeAccent : Color(.systemGray5))
                            .frame(height: 2)
                            .offset(y: 18)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func isComplete(_ step: Step) -> Bool {
        let order = Step.allCases
        guard let target = order.firstIndex(of: step),
              let current = order.firstIndex(of: currentStep)
        else { return false }
        return target <= current
    }
}

struct NutritionFactsCard: View {
    let servingSize: String
    let caffeineMg: Int
    let calories: Int
    let highlights: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition")
                .font(.headline)
            Text("Per \(servingSize)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Divider()
            HStack(spacing: 18) {
                stat(label: "Caffeine", value: "\(caffeineMg)", unit: "mg")
                stat(label: "Calories", value: "\(calories)", unit: "kcal")
            }
            Divider()
            VStack(alignment: .leading, spacing: 6) {
                ForEach(highlights, id: \.0) { item in
                    HStack {
                        Text(item.0).font(.subheadline)
                        Spacer()
                        Text(item.1)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func stat(label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value).font(.title3.bold().monospacedDigit())
                Text(unit).font(.caption).foregroundStyle(.secondary)
            }
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private let weekdayHours: [StoreHoursWidget.DayHours] = [
    .init(day: "Mon", hours: "7:00 — 18:00", isToday: false),
    .init(day: "Tue", hours: "7:00 — 18:00", isToday: false),
    .init(day: "Wed", hours: "7:00 — 18:00", isToday: true),
    .init(day: "Thu", hours: "7:00 — 18:00", isToday: false),
    .init(day: "Fri", hours: "7:00 — 20:00", isToday: false),
    .init(day: "Sat", hours: "8:00 — 20:00", isToday: false),
    .init(day: "Sun", hours: "9:00 — 16:00", isToday: false)
]

#Preview("DailySpecialBanner / Flash Sale") {
    DailySpecialBanner(
        title: "Flash Sale",
        subtitle: "Single origin beans, today only",
        discountLabel: "-30%",
        endsAt: "midnight"
    )
    .padding()
}

#Preview("DailySpecialBanner / Happy Hour") {
    DailySpecialBanner(
        title: "Happy Hour",
        subtitle: "BOGO espresso drinks",
        discountLabel: "BOGO",
        endsAt: "5pm"
    )
    .padding()
}

#Preview("StoreHoursWidget / Open Now") {
    StoreHoursWidget(storeName: "Mission St. Roastery", isOpen: true, days: weekdayHours).padding()
}

#Preview("StoreHoursWidget / Closed") {
    StoreHoursWidget(storeName: "Mission St. Roastery", isOpen: false, days: weekdayHours).padding()
}

#Preview("DeliveryEstimateWidget / Express") {
    DeliveryEstimateWidget(address: "350 Mission St, San Francisco", etaMinutes: 22, isFast: true).padding()
}

#Preview("DeliveryEstimateWidget / Standard") {
    DeliveryEstimateWidget(address: "350 Mission St, San Francisco", etaMinutes: 75, isFast: false).padding()
}

#Preview("RatingSummaryWidget / 4.6 Stars") {
    RatingSummaryWidget(
        average: 4.6,
        total: 1284,
        distribution: [892, 248, 88, 36, 20]
    )
    .padding()
}

#Preview("RatingSummaryWidget / 3.2 Stars") {
    RatingSummaryWidget(
        average: 3.2,
        total: 180,
        distribution: [40, 32, 50, 30, 28]
    )
    .padding()
}

#Preview("OrderStatusTimeline / Placed") {
    OrderStatusTimeline(currentStep: .placed, estimatedDelivery: "Friday, May 16").padding()
}

#Preview("OrderStatusTimeline / Roasting") {
    OrderStatusTimeline(currentStep: .roasting, estimatedDelivery: "Friday, May 16").padding()
}

#Preview("OrderStatusTimeline / Shipped") {
    OrderStatusTimeline(currentStep: .shipped, estimatedDelivery: "Friday, May 16").padding()
}

#Preview("OrderStatusTimeline / Delivered") {
    OrderStatusTimeline(currentStep: .delivered, estimatedDelivery: "Delivered today").padding()
}

#Preview("NutritionFactsCard / Espresso Shot") {
    NutritionFactsCard(
        servingSize: "1 oz shot",
        caffeineMg: 64,
        calories: 5,
        highlights: [("Sugar", "0g"), ("Fat", "0g"), ("Protein", "<1g")]
    )
    .padding()
}

#Preview("NutritionFactsCard / Latte") {
    NutritionFactsCard(
        servingSize: "12 oz latte",
        caffeineMg: 128,
        calories: 180,
        highlights: [("Sugar", "18g"), ("Fat", "7g"), ("Protein", "11g")]
    )
    .padding()
}
