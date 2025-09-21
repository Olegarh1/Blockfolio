import Foundation

// Represents a Global Data entity parsed from JSON response
struct GlobalData: Identifiable, Codable {
    var id = UUID().uuidString
    
    let activeCryptocurrencies: Int?
    let totalMarketCap: [String: Double]?
    let totalVolume: [String: Double]?
    let marketCapPercentage: [String: Double]?
    let marketCapChangePercentage24HUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    /// Зручно діставати USD напряму
    var marketCapUsd: Double {
        totalMarketCap?["usd"] ?? 0.0
    }
    
    var volumeUsd: Double {
        totalVolume?["usd"] ?? 0.0
    }
    
    var btcDominance: Double {
        marketCapPercentage?["btc"] ?? 0.0
    }
    
    var ethDominance: Double {
        marketCapPercentage?["eth"] ?? 0.0
    }
}
