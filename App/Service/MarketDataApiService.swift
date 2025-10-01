import Foundation
import Combine

class MarketDataApiService {
    @Published var allCoins: [Coin] = []
    @Published var lastUpdated = ""
    
    private let decoder: JSONDecoder
    private var subscribers = Set<AnyCancellable>()
    private let networking: NetworkingManaging.Type
    
    init(networking: NetworkingManaging.Type = NetworkingManager.self) {
        self.networking = networking
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(GeneralUtility.lastUpdatedDateFormatter)
        
        getAllCoins()
    }
    
    func getAllCoins() {
        guard let url = URL(string: GeneralUtility.serverBaseUrl + "/api/v3/coins/markets?vs_currency=usd&sparkline=true") else { return }
        
        networking.download(url: url)
            .decode(type: [Coin].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    print("❌ MarketDataApiService error: \(error)")
                case .finished:
                    print("✅ MarketDataApiService finished successfully")
                }
            }, receiveValue: { [weak self] container in
                self?.allCoins = container
            })
            .store(in: &subscribers)
    }
}
