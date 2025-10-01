import Foundation

// Represents a coin parsed from container from JSON response
struct Coin: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    
    let currentPrice: Double
    let marketCapRank: Int
    
    let marketCap: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let sparklineIn7D: SparklineIn7D?
    let sparklineLastUpdated: String?
    
    let priceChangePercentage7D: Double?
    let priceChangePercentage14D: Double?
    let priceChangePercentage30D: Double?
    let priceChangePercentage1Y: Double?
    
    let recommendedCoins: [String]?
    let blockTime: Int?
    let hashingAlgorithm: String?
    let description: String?
    let homepageUrl: String?
    let subredditUrl: String?
    let genesisDate: String?
    let positiveSentimentPercentage: Double?
    
    let currentHoldings: Double?
    let costBasis: Double?
    
    var currentHoldingsValue: Double { // Dynamically calculate current holdings value based on holdings * price
        if currentHoldings == nil {
            return 0.0
        } else {
            return currentHoldings! * currentPrice }
    }
    
    var averageCostPerCoin: Double { // Dynamically calculate average cost per coin based on cost basis / holdings
        if let costBasis = costBasis, let currentHoldings = currentHoldings {
            if currentHoldings != 0.0 {
                return costBasis / currentHoldings
            }
        }
        return 0.0
    }
    // Profit/loss (if cost basis available)
    var profitLossAmount: Double {
        if let costBasis = costBasis {
            return currentHoldingsValue - costBasis
        } else {
            return 0.0 }
    }
    var profitLossPercentage: Double {
        if let costBasis = costBasis {
            if costBasis != 0.0 { // Calculate percent change by subtracting cost basis value from value and dividing by cost basis
                return ((currentHoldingsValue - costBasis) / costBasis) * 100.0
            }
        }
        return 0.0
    }
        
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case sparklineIn7D = "sparkline_in_7d"
        case sparklineLastUpdated = "last_updated"
        case priceChangePercentage7D = "price_change_percentage_7d_in_currency"
        case priceChangePercentage14D = "price_change_percentage_14d_in_currency"
        case priceChangePercentage30D = "price_change_percentage_30d_in_currency"
        case priceChangePercentage1Y = "price_change_percentage_1y_in_currency"
        case recommendedCoins, blockTime, hashingAlgorithm, description
        case homepageUrl = "homepage"
        case subredditUrl = "subreddit_url"
        case genesisDate = "genesis_date"
        case positiveSentimentPercentage = "sentiment_votes_up_percentage"
        case currentHoldings, costBasis
    }
}

extension Coin {
    // Update the user's current holdings and returns a new coin with updated holdings + cost basis
    func updateCoin(updatedHoldings: Double, updatedCostBasis: Double) -> Coin {
        var copy = self
        copy = Coin(id: self.id,
                    symbol: self.symbol,
                    name: self.name,
                    image: self.image,
                    currentPrice: self.currentPrice,
                    marketCapRank: self.marketCapRank,
                    marketCap: self.marketCap,
                    fullyDilutedValuation: self.fullyDilutedValuation,
                    totalVolume: self.totalVolume,
                    high24H: self.high24H,
                    low24H: self.low24H,
                    priceChange24H: self.priceChange24H,
                    priceChangePercentage24H: self.priceChangePercentage24H,
                    marketCapChange24H: self.marketCapChange24H,
                    marketCapChangePercentage24H: self.marketCapChangePercentage24H,
                    circulatingSupply: self.circulatingSupply,
                    totalSupply: self.totalSupply,
                    maxSupply: self.maxSupply,
                    ath: self.ath,
                    athChangePercentage: self.athChangePercentage,
                    athDate: self.athDate,
                    atl: self.atl,
                    atlChangePercentage: self.atlChangePercentage,
                    atlDate: self.atlDate,
                    sparklineIn7D: self.sparklineIn7D,
                    sparklineLastUpdated: self.sparklineLastUpdated,
                    priceChangePercentage7D: self.priceChangePercentage7D,
                    priceChangePercentage14D: self.priceChangePercentage14D,
                    priceChangePercentage30D: self.priceChangePercentage30D,
                    priceChangePercentage1Y: self.priceChangePercentage1Y,
                    recommendedCoins: self.recommendedCoins,
                    blockTime: self.blockTime,
                    hashingAlgorithm: self.hashingAlgorithm,
                    description: self.description,
                    homepageUrl: self.homepageUrl,
                    subredditUrl: self.subredditUrl,
                    genesisDate: self.genesisDate,
                    positiveSentimentPercentage: self.positiveSentimentPercentage,
                    currentHoldings: updatedHoldings,
                    costBasis: updatedCostBasis)
        return copy
    }
}

extension Coin {
    init(id: String, symbol: String, name: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = ""
        self.currentPrice = 0.0
        self.marketCapRank = 0
        self.marketCap = nil
        self.fullyDilutedValuation = nil
        self.totalVolume = nil
        self.high24H = nil
        self.low24H = nil
        self.priceChange24H = nil
        self.priceChangePercentage24H = nil
        self.marketCapChange24H = nil
        self.marketCapChangePercentage24H = nil
        self.circulatingSupply = nil
        self.totalSupply = nil
        self.maxSupply = nil
        self.ath = nil
        self.athChangePercentage = nil
        self.athDate = nil
        self.atl = nil
        self.atlChangePercentage = nil
        self.atlDate = nil
        self.sparklineIn7D = nil
        self.sparklineLastUpdated = nil
        self.priceChangePercentage7D = nil
        self.priceChangePercentage14D = nil
        self.priceChangePercentage30D = nil
        self.priceChangePercentage1Y = nil
        self.recommendedCoins = nil
        self.blockTime = nil
        self.hashingAlgorithm = nil
        self.description = nil
        self.homepageUrl = nil
        self.subredditUrl = nil
        self.genesisDate = nil
        self.positiveSentimentPercentage = nil
        self.currentHoldings = nil
        self.costBasis = nil
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
