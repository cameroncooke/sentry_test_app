import Foundation
import SwiftUI

enum RoastLevel: String, CaseIterable, Identifiable {
    case light = "Light"
    case medium = "Medium"
    case mediumDark = "Medium-Dark"
    case dark = "Dark"

    var id: String { rawValue }

    var indicatorCount: Int {
        switch self {
        case .light: return 1
        case .medium: return 2
        case .mediumDark: return 3
        case .dark: return 4
        }
    }

    var color: Color {
        switch self {
        case .light: return Color(red: 0.82, green: 0.66, blue: 0.45)
        case .medium: return Color(red: 0.55, green: 0.36, blue: 0.20)
        case .mediumDark: return Color(red: 0.38, green: 0.22, blue: 0.12)
        case .dark: return Color(red: 0.20, green: 0.11, blue: 0.06)
        }
    }
}

enum BrewMethod: String, CaseIterable, Identifiable {
    case espresso = "Espresso"
    case pourOver = "Pour Over"
    case frenchPress = "French Press"
    case aeropress = "AeroPress"
    case coldBrew = "Cold Brew"
    case chemex = "Chemex"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .espresso: return "cup.and.saucer.fill"
        case .pourOver: return "drop.fill"
        case .frenchPress: return "cylinder.fill"
        case .aeropress: return "arrow.down.circle.fill"
        case .coldBrew: return "snowflake"
        case .chemex: return "triangle.fill"
        }
    }
}

enum StockStatus {
    case inStock(remaining: Int)
    case lowStock(remaining: Int)
    case outOfStock
    case preorder(shipDate: String)

    var label: String {
        switch self {
        case .inStock: return "In stock"
        case .lowStock(let n): return "Only \(n) left"
        case .outOfStock: return "Sold out"
        case .preorder(let date): return "Preorder · ships \(date)"
        }
    }

    var color: Color {
        switch self {
        case .inStock: return .green
        case .lowStock: return .orange
        case .outOfStock: return .red
        case .preorder: return .blue
        }
    }
}

struct CoffeeProduct: Identifiable {
    let id = UUID()
    let name: String
    let origin: String
    let roast: RoastLevel
    let priceCents: Int
    let originalPriceCents: Int?
    let tastingNotes: [String]
    let rating: Double
    let reviewCount: Int
    let stock: StockStatus
    let imageSymbol: String

    var price: String { Self.format(cents: priceCents) }
    var originalPrice: String? {
        originalPriceCents.map { Self.format(cents: $0) }
    }
    var isOnSale: Bool { originalPriceCents != nil }

    static func format(cents: Int) -> String {
        String(format: "$%.2f", Double(cents) / 100.0)
    }
}

enum SampleData {
    static let ethiopia = CoffeeProduct(
        name: "Yirgacheffe Reserve",
        origin: "Ethiopia",
        roast: .light,
        priceCents: 2200,
        originalPriceCents: nil,
        tastingNotes: ["Jasmine", "Bergamot", "Stone fruit"],
        rating: 4.8,
        reviewCount: 312,
        stock: .inStock(remaining: 48),
        imageSymbol: "leaf.fill"
    )

    static let colombia = CoffeeProduct(
        name: "Huila Single Origin",
        origin: "Colombia",
        roast: .medium,
        priceCents: 1850,
        originalPriceCents: 2400,
        tastingNotes: ["Caramel", "Milk chocolate", "Orange"],
        rating: 4.6,
        reviewCount: 1284,
        stock: .lowStock(remaining: 3),
        imageSymbol: "mountain.2.fill"
    )

    static let sumatra = CoffeeProduct(
        name: "Mandheling Dark",
        origin: "Sumatra",
        roast: .dark,
        priceCents: 1995,
        originalPriceCents: nil,
        tastingNotes: ["Cedar", "Dark cocoa", "Tobacco"],
        rating: 4.4,
        reviewCount: 542,
        stock: .outOfStock,
        imageSymbol: "flame.fill"
    )

    static let kenya = CoffeeProduct(
        name: "Nyeri AA",
        origin: "Kenya",
        roast: .mediumDark,
        priceCents: 2650,
        originalPriceCents: 2950,
        tastingNotes: ["Black currant", "Brown sugar", "Lime"],
        rating: 4.9,
        reviewCount: 88,
        stock: .preorder(shipDate: "Jun 12"),
        imageSymbol: "sun.max.fill"
    )

    static let all: [CoffeeProduct] = [ethiopia, colombia, sumatra, kenya]
}

extension Color {
    static let coffeeCream = Color(red: 0.96, green: 0.91, blue: 0.82)
    static let coffeeEspresso = Color(red: 0.24, green: 0.13, blue: 0.08)
    static let coffeeAccent = Color(red: 0.71, green: 0.44, blue: 0.20)
}
