import Foundation

// Represents a trending coin from trending data response object parsed from JSON response
struct TrendingCoin: Identifiable, Codable {
    let id: String
    let coinId: Int
    let name: String
    let symbol: String
    let marketCapRank: Int?
    let largeImage: String
    let score: Int
    
    let trendingScore: Int = 0
    let price: Double? = nil
    let marketCap: Double? = nil
    let volume: Double? = nil
    let priceChangePercentage24H: Double? = nil
    let description: String? = nil

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, score
        case largeImage = "large"
        case coinId = "coin_id"
        case marketCapRank = "market_cap_rank"
    }
}


struct TrendingResponse: Codable {
    let coins: [TrendingItem]
}

struct TrendingItem: Codable {
    let item: TrendingCoin
}
