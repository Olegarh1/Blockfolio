import Foundation
import Combine

class TrendingDataApiService {
    @Published var trendingCoins: [TrendingCoin] = []
    @Published var lastUpdated = ""
    
    private let decoder = JSONDecoder()
    
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        getTrendingCoins()
    }
    
    // Updates published trending coin data
    func getTrendingCoins() {
        guard let url = URL(string: GeneralUtility.serverBaseUrl + "/api/v3/search/trending") else { return }
        
        NetworkingManager.download(url: url)
            .decode(type: TrendingResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    print("❌ TrendingDataApiService Network / Decoding error: \(error)")
                case .finished:
                    print("✅ TrendingDataApiService Request finished successfully")
                }
            }, receiveValue: { [weak self] response in
                self?.trendingCoins = response.coins.map { $0.item }
                self?.lastUpdated = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            })
            .store(in: &subscribers)

    }
}
